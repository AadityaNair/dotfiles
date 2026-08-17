/**
 * Memory Extension
 *
 * Gives pi a durable, file-based memory system, deliberately modeled on the
 * memory convention already used for Claude Code
 * (~/.config/claude/projects/.../memory/: one fact per markdown file with
 * frontmatter, plus a MEMORY.md index) so there's one mental model across
 * both agents. Written by hand rather than installing pi-memory or
 * pi-hermes-memory - those bring semantic search / vector stores that
 * weren't asked for and add real dependency weight for a "few dozen facts"
 * problem. See pi/plan.md's "#6 Memory" section for the original call.
 *
 * Storage lives under <agent-dir>/memory/, NOT under this extensions/ dir:
 * memory is personal machine-local state (like sessions/ or auth.json),
 * not shareable config, so it never lands inside this git repo at all -
 * same reasoning as why sessions/, bin/, auth.json are in pi/.gitignore.
 *
 * Two pieces:
 *  1. `remember` / `forget` tools so the LLM can write/delete memory files.
 *  2. A before_agent_start hook that re-reads MEMORY.md fresh on every turn
 *     and appends its contents to the system prompt.
 *
 * DECISION: before_agent_start vs. the `context` hook.
 * The `context` hook only lets you filter/rewrite the messages array, not
 * append arbitrary text to the system prompt. before_agent_start explicitly
 * hands back `event.systemPrompt` for extensions to extend - see pi's own
 * examples/extensions/pirate.ts for the reference pattern this copies.
 *
 * DECISION: read fresh every turn instead of loading once at session start.
 * AGENTS.md/SYSTEM.md are only read once when the session boots. If we did
 * the same for memory, a `remember` call made earlier in THIS session
 * wouldn't be visible until the next session started. Re-reading on every
 * before_agent_start costs one small file read per turn and means new
 * memories apply immediately.
 *
 * NOT implemented (deliberately out of scope for a first pass):
 *  - No dedup/merge logic beyond "same slug overwrites". If the LLM writes
 *    near-duplicate memories under different slugs, nothing catches that.
 *  - No size cap on MEMORY.md. If this grows unbounded it'll eat context
 *    budget every turn - worth revisiting if it gets past ~50 entries.
 */

import { existsSync } from "node:fs";
import { mkdir, readFile, unlink, writeFile } from "node:fs/promises";
import * as path from "node:path";

import { StringEnum } from "@earendil-works/pi-ai";
import { getAgentDir, type ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";

const MEMORY_DIR = path.join(getAgentDir(), "memory");
const INDEX_PATH = path.join(MEMORY_DIR, "MEMORY.md");

// Mirrors the Claude Code memory taxonomy on purpose - see the "types" list
// in ~/.config/claude/CLAUDE.md's auto-memory instructions.
const MEMORY_TYPES = ["user", "feedback", "project", "reference"] as const;

function slugify(name: string): string {
	return name
		.trim()
		.toLowerCase()
		.replace(/[^a-z0-9]+/g, "-")
		.replace(/^-+|-+$/g, "");
}

async function ensureMemoryDir(): Promise<void> {
	if (!existsSync(MEMORY_DIR)) {
		await mkdir(MEMORY_DIR, { recursive: true });
	}
}

async function readIndexLines(): Promise<string[]> {
	if (!existsSync(INDEX_PATH)) return [];
	const raw = await readFile(INDEX_PATH, "utf-8");
	return raw.split("\n").filter((line) => line.trim().length > 0);
}

async function writeIndexLines(lines: string[]): Promise<void> {
	await writeFile(INDEX_PATH, lines.length > 0 ? `${lines.join("\n")}\n` : "", "utf-8");
}

function indexLine(slug: string, description: string): string {
	return `- [${slug}](${slug}.md) — ${description}`;
}

export default function (pi: ExtensionAPI) {
	pi.registerTool({
		name: "remember",
		label: "Remember",
		description:
			"Save a durable fact to persistent memory that survives across pi sessions. Use for user " +
			"preferences, feedback about how to work, ongoing project context, or pointers to external " +
			"systems. Do NOT use for code patterns, git history, or anything derivable by reading the repo " +
			"- those go stale and are cheap to re-derive.",
		promptSnippet: "Save a durable fact to cross-session memory",
		promptGuidelines: [
			"Use remember only for facts that matter in a FUTURE session, not for tracking today's task - use appendEntry-style session state or plain conversation for that.",
			"Before saving with remember, check MEMORY.md (already in your context) for an existing entry to update instead of creating a near-duplicate.",
		],
		parameters: Type.Object({
			name: Type.String({ description: "Short kebab-case slug, e.g. 'user-role' or 'feedback-testing'" }),
			type: StringEnum(MEMORY_TYPES, { description: "user | feedback | project | reference" }),
			description: Type.String({ description: "One-line summary shown in the MEMORY.md index (~150 chars)" }),
			content: Type.String({
				description:
					"Full memory body in markdown. For feedback/project types, lead with the rule/fact, then a **Why:** line and a **How to apply:** line.",
			}),
		}),
		async execute(_toolCallId, params) {
			await ensureMemoryDir();
			const slug = slugify(params.name);
			const filePath = path.join(MEMORY_DIR, `${slug}.md`);

			const frontmatter = `---\nname: ${slug}\ndescription: ${params.description}\nmetadata:\n  type: ${params.type}\n---\n\n`;
			await writeFile(filePath, frontmatter + params.content.trim() + "\n", "utf-8");

			const lines = (await readIndexLines()).filter((line) => !line.startsWith(`- [${slug}]`));
			lines.push(indexLine(slug, params.description));
			await writeIndexLines(lines);

			return {
				content: [{ type: "text", text: `Saved memory '${slug}' (${params.type}) to ${filePath}.` }],
				details: { slug, type: params.type, path: filePath },
			};
		},
	});

	pi.registerTool({
		name: "forget",
		label: "Forget",
		description: "Delete a previously saved memory by its slug (as shown in the MEMORY.md index).",
		promptSnippet: "Delete a saved memory by slug",
		promptGuidelines: ["Use forget when the user explicitly asks to remove a remembered fact."],
		parameters: Type.Object({
			name: Type.String({ description: "Slug of the memory to delete" }),
		}),
		async execute(_toolCallId, params) {
			const slug = slugify(params.name);
			const filePath = path.join(MEMORY_DIR, `${slug}.md`);
			const existed = existsSync(filePath);
			if (existed) {
				await unlink(filePath);
			}

			const lines = (await readIndexLines()).filter((line) => !line.startsWith(`- [${slug}]`));
			await writeIndexLines(lines);

			return {
				content: [
					{
						type: "text",
						text: existed ? `Forgot memory '${slug}'.` : `No memory file found for '${slug}', removed any stale index entry.`,
					},
				],
				details: { slug, existed },
			};
		},
	});

	pi.on("before_agent_start", async (event) => {
		if (!existsSync(INDEX_PATH)) return undefined;

		const index = (await readFile(INDEX_PATH, "utf-8")).trim();
		if (!index) return undefined;

		return {
			systemPrompt:
				`${event.systemPrompt}\n\n<persistent_memory>\n` +
				`Facts remembered from previous sessions via the remember/forget tools. ` +
				`These are index entries, not full context - read the linked file under ${MEMORY_DIR} ` +
				`before treating a memory that names a specific file/function/flag as still accurate.\n\n` +
				`${index}\n</persistent_memory>\n`,
		};
	});
}
