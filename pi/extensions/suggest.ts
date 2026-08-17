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
 * DECISION: a real (but free, capped) extra LLM call, not pure heuristics.
 * A heuristic version (e.g. "suggest running tests if source files
 * changed") would be free but low quality and full of special cases. This
 * spends one small completion per idle turn instead, using a model already
 * in the enabledModels allowlist (see settings.json) so it costs nothing.
 * If that model becomes unavailable or the allowlist changes, this needs a
 * fallback - see SUGGESTION_MODEL below.
 *
 * NOT implemented:
 *  - No caching/dedup of suggestions across turns - every settle re-asks.
 *  - No user-facing toggle/command to turn this off; if it gets annoying,
 *    the quick fix is commenting out the pi.on("agent_settled", ...) call
 *    below, or adding a registerCommand("suggest") toggle like pirate.ts.
 */

import { complete, type UserMessage } from "@earendil-works/pi-ai";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

// Free model from the enabledModels allowlist in settings.json. Picked
// big-pickle over deepseek-v4-flash-free/etc arbitrarily - any allowlisted
// free model works here, this just needs to be cheap and fast since it
// runs after every idle turn.
const SUGGESTION_PROVIDER = "opencode";
const SUGGESTION_MODEL_ID = "big-pickle";

const SUGGESTION_SYSTEM_PROMPT = `You suggest what a developer might want to do next, based on the tail of a coding-agent transcript.
Reply with 2-3 short suggestions, one per line, each a plain imperative phrase (e.g. "Run the test suite", "Commit these changes").
No numbering, no markdown, no explanation. If nothing sensible comes to mind, reply with a single line: (none)`;

// Keep the prompt payload small - this is a cheap suggestion call, not a
// full context replay. Last few messages are enough signal for "what's next".
const MAX_TAIL_MESSAGES = 6;
const MAX_CHARS_PER_MESSAGE = 2000;

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
	pi.on("agent_settled", async (_event, ctx) => {
		if (!ctx.hasUI) return;

		const model = ctx.modelRegistry.find(SUGGESTION_PROVIDER, SUGGESTION_MODEL_ID);
		if (!model) {
			// Allowlist/catalog drifted since this was written - fail silent
			// rather than nag every turn. See settings.json enabledModels.
			return;
		}

		const auth = await ctx.modelRegistry.getApiKeyAndHeaders(model);
		if (auth.ok === false) return;

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
			.slice(-MAX_TAIL_MESSAGES);

		if (messages.length === 0) return;

		const transcriptTail = messages
			.map((m) => `${m.message.role === "user" ? "User" : "Assistant"}: ${summarizeContent(m.message.content).slice(0, MAX_CHARS_PER_MESSAGE)}`)
			.join("\n\n");

		const userMessage: UserMessage = {
			role: "user",
			content: [{ type: "text", text: transcriptTail }],
			timestamp: Date.now(),
		};

		try {
			const response = await complete(
				model,
				{ systemPrompt: SUGGESTION_SYSTEM_PROMPT, messages: [userMessage] },
				{ apiKey: auth.apiKey, headers: auth.headers },
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
