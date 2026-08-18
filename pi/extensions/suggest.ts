/**
 * Autosuggestions Extension
 *
 * Offers 2-3 short "what next?" suggestions once pi has genuinely finished
 * and is waiting for input. Hand-written - no official example or vendored
 * package covers this (checked pi's ~70 bundled examples and
 * mitsuhiko/agent-stuff, neither has it).
 *
 * DECISION: agent_settled, not agent_end.
 * agent_end fires when a single low-level run ends, but pi may still
 * auto-retry, auto-compact, or continue with a queued follow-up right
 * after. agent_settled only fires once none of that is going to happen -
 * the right gate so suggestions don't get generated (and immediately
 * thrown away) mid-retry.
 *
 * DECISION: a real, capped extra LLM call, not pure heuristics.
 * A heuristic version (e.g. "suggest running tests if source files
 * changed") would be cheap but low quality and full of special cases. The
 * provider, model, effort, and prompt-tail limits are configured under
 * settings.json -> aadityaCustomItems.suggest.
 *
 * NOT implemented:
 *  - No caching/dedup of suggestions across turns - every settle re-asks.
 *  - No user-facing toggle/command to turn this off; if it gets annoying,
 *    the quick fix is commenting out the pi.on("agent_settled", ...) call
 *    below, or adding a registerCommand("suggest") toggle like pirate.ts.
 */

import { readFileSync } from "node:fs";
import { join } from "node:path";

import type { UserMessage } from "@earendil-works/pi-ai";
import { getAgentDir, type ExtensionAPI } from "@earendil-works/pi-coding-agent";

const EFFORT_LEVELS = ["off", "minimal", "low", "medium", "high", "xhigh", "max"] as const;
type EffortLevel = (typeof EFFORT_LEVELS)[number];

type SuggestConfig = {
	provider: string;
	modelId: string;
	effortLevel: EffortLevel;
	maxTailMessages: number;
	maxCharsPerMessage: number;
};

const DEFAULT_CONFIG: SuggestConfig = {
	provider: "opencode",
	modelId: "big-pickle",
	effortLevel: "low",
	maxTailMessages: 6,
	maxCharsPerMessage: 2000,
};

function isEffortLevel(value: unknown): value is EffortLevel {
	return typeof value === "string" && (EFFORT_LEVELS as readonly string[]).includes(value);
}

function positiveInteger(value: unknown, fallback: number): number {
	return typeof value === "number" && Number.isSafeInteger(value) && value > 0 ? value : fallback;
}

function loadSuggestConfig(): SuggestConfig {
	const settingsPath = join(getAgentDir(), "settings.json");
	try {
		const settings = JSON.parse(readFileSync(settingsPath, "utf8")) as {
			aadityaCustomItems?: { suggest?: Partial<SuggestConfig> };
		};
		const configured = settings.aadityaCustomItems?.suggest;
		return {
			provider:
				typeof configured?.provider === "string" && configured.provider.trim()
					? configured.provider.trim()
					: DEFAULT_CONFIG.provider,
			modelId:
				typeof configured?.modelId === "string" && configured.modelId.trim()
					? configured.modelId.trim()
					: DEFAULT_CONFIG.modelId,
			effortLevel: isEffortLevel(configured?.effortLevel)
				? configured.effortLevel
				: DEFAULT_CONFIG.effortLevel,
			maxTailMessages: positiveInteger(configured?.maxTailMessages, DEFAULT_CONFIG.maxTailMessages),
			maxCharsPerMessage: positiveInteger(configured?.maxCharsPerMessage, DEFAULT_CONFIG.maxCharsPerMessage),
		};
	} catch (error) {
		console.error(
			`Suggest: Could not load ${settingsPath}: ${error instanceof Error ? error.message : String(error)}`,
		);
		return { ...DEFAULT_CONFIG };
	}
}

const SUGGESTION_SYSTEM_PROMPT = `You suggest what a developer might want to do next, based on the tail of a coding-agent transcript.
Reply with 2-3 short suggestions, one per line, each a plain imperative phrase (e.g. "Run the test suite", "Commit these changes").
No numbering, no markdown, no explanation. If nothing sensible comes to mind, reply with a single line: (none)`;

function summarizeContent(content: unknown): string {
	if (typeof content === "string") return content;
	if (Array.isArray(content)) {
		return content
			.map((part) => (part && typeof part === "object" && "text" in part ? String((part as { text: unknown }).text) : ""))
			.join(" ");
	}
	return "";
}

export default function (pi: ExtensionAPI) {
	let config = loadSuggestConfig();

	pi.on("session_start", () => {
		config = loadSuggestConfig();
	});

	pi.on("agent_settled", async (_event, ctx) => {
		if (!ctx.hasUI) return;

		const model = ctx.modelRegistry.find(config.provider, config.modelId);
		if (!model) {
			// Invalid or unavailable configured model: suggestions are best-effort,
			// so fail silently rather than interrupting the main workflow.
			return;
		}

		// Session entries are { type: "message", message: { role, content, ... } }
		// per docs/session-format.md - NOT { type: "user" | "assistant" } as a
		// first guess might assume. Filtered/mapped here rather than trusting
		// a narrower SDK type, since ExtensionContext doesn't export one.
		const messages = ctx.sessionManager
			.getEntries()
			.filter(
				(e): e is typeof e & { type: "message"; message: { role: "user" | "assistant"; content: unknown } } =>
					(e as { type?: unknown }).type === "message" &&
					((e as { message?: { role?: unknown } }).message?.role === "user" ||
						(e as { message?: { role?: unknown } }).message?.role === "assistant"),
			)
			.slice(-config.maxTailMessages);

		if (messages.length === 0) return;

		const transcriptTail = messages
			.map(
				(m) =>
					`${m.message.role === "user" ? "User" : "Assistant"}: ${summarizeContent(m.message.content).slice(0, config.maxCharsPerMessage)}`,
			)
			.join("\n\n");

		const userMessage: UserMessage = {
			role: "user",
			content: [{ type: "text", text: transcriptTail }],
			timestamp: Date.now(),
		};

		try {
			const response = await ctx.modelRegistry.complete(
				model,
				{ systemPrompt: SUGGESTION_SYSTEM_PROMPT, messages: [userMessage] },
				{ reasoningEffort: config.effortLevel },
			);

			if (response.stopReason === "aborted" || response.stopReason === "error") return;

			const text = response.content
				.filter((c): c is { type: "text"; text: string } => c.type === "text")
				.map((c) => c.text)
				.join("\n")
				.trim();

			if (!text || text === "(none)") {
				ctx.ui.setWidget("suggest", undefined);
				return;
			}

			const lines = text
				.split("\n")
				.map((l) => l.trim())
				.filter(Boolean)
				.slice(0, 3)
				.map((l) => `  → ${l}`);

			ctx.ui.setWidget("suggest", lines);
		} catch {
			// Best-effort feature - never let a failed suggestion call surface
			// as an error to the user.
		}
	});
}
