/**
 * Permissions Extension
 *
 * Vendored and merged from pi's own bundled official examples
 * (pi-coding-agent v0.84.2, examples/extensions/), first-party and MIT:
 *   - permission-gate.ts  (confirm before dangerous bash)
 *   - protected-paths.ts  (block writes to sensitive paths)
 *   - dirty-repo-guard.ts (block session switch/fork with uncommitted changes)
 * https://github.com/earendil-works/pi/tree/main/packages/coding-agent/examples/extensions
 * Diff against that path to check for upstream drift.
 *
 * DECISION: merged into one file instead of three, since pi has no native
 * "permission system" TODO item beyond "confirm risky stuff" - three small
 * files for one concern felt like more ceremony than the ~120 total lines
 * warrant. If these grow independent logic later, split them back out.
 *
 * NOT reviewed/adjusted beyond the source scan done before vendoring: the
 * dangerous-bash regex list and protected-paths list below are the
 * examples' originals. Worth tuning for this specific setup (e.g. add
 * `.pi/settings.json`, `web-search.json`, `auth.json` to protected paths)
 * next time this file gets revisited.
 */

import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

// --- permission-gate.ts -----------------------------------------------
// Prompts for confirmation before running potentially dangerous bash commands.
const dangerousPatterns = [/\brm\s+(-rf?|--recursive)/i, /\bsudo\b/i, /\b(chmod|chown)\b.*777/i];

// --- protected-paths.ts -------------------------------------------------
// Blocks write and edit operations to protected paths.
const protectedPaths = [".env", ".git/", "node_modules/"];

async function checkDirtyRepo(
	pi: ExtensionAPI,
	ctx: ExtensionContext,
	action: string,
): Promise<{ cancel: boolean } | undefined> {
	const { stdout, code } = await pi.exec("git", ["status", "--porcelain"]);

	if (code !== 0) {
		// Not a git repo, allow the action.
		return;
	}

	const hasChanges = stdout.trim().length > 0;
	if (!hasChanges) {
		return;
	}

	if (!ctx.hasUI) {
		// In non-interactive mode, block by default.
		return { cancel: true };
	}

	const changedFiles = stdout.trim().split("\n").filter(Boolean).length;

	const choice = await ctx.ui.select(`You have ${changedFiles} uncommitted file(s). ${action} anyway?`, [
		"Yes, proceed anyway",
		"No, let me commit first",
	]);

	if (choice !== "Yes, proceed anyway") {
		ctx.ui.notify("Commit your changes first", "warning");
		return { cancel: true };
	}
}

export default function (pi: ExtensionAPI) {
	pi.on("tool_call", async (event, ctx) => {
		// permission-gate.ts: dangerous bash commands.
		if (event.toolName === "bash") {
			const command = event.input.command as string;
			const isDangerous = dangerousPatterns.some((p) => p.test(command));

			if (isDangerous) {
				if (!ctx.hasUI) {
					return { block: true, reason: "Dangerous command blocked (no UI for confirmation)" };
				}

				const choice = await ctx.ui.select(`⚠️ Dangerous command:\n\n  ${command}\n\nAllow?`, ["Yes", "No"]);

				if (choice !== "Yes") {
					return { block: true, reason: "Blocked by user" };
				}
			}

			return undefined;
		}

		// protected-paths.ts: writes/edits to sensitive paths.
		if (event.toolName === "write" || event.toolName === "edit") {
			const path = event.input.path as string;
			const isProtected = protectedPaths.some((p) => path.includes(p));

			if (isProtected) {
				if (ctx.hasUI) {
					ctx.ui.notify(`Blocked write to protected path: ${path}`, "warning");
				}
				return { block: true, reason: `Path "${path}" is protected` };
			}
		}

		return undefined;
	});

	// dirty-repo-guard.ts: refuse to switch/fork sessions with uncommitted changes.
	pi.on("session_before_switch", async (event, ctx) => {
		const action = event.reason === "new" ? "new session" : "switch session";
		return checkDirtyRepo(pi, ctx, action);
	});

	pi.on("session_before_fork", async (_event, ctx) => {
		return checkDirtyRepo(pi, ctx, "fork");
	});
}
