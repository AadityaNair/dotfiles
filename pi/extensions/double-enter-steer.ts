/**
 * Double-Enter Steer Extension
 *
 * TODO item was "Enter to queue messages, Enter+Enter to interrupt and
 * steer faster". Half of that is already native and needed zero code:
 * per docs/usage.md, plain Enter while pi is streaming already queues a
 * steering message, delivered after the current turn's tool calls finish.
 * This extension only adds the missing half - pressing Enter AGAIN while
 * one is already queued jumps the queue by interrupting immediately,
 * instead of waiting for the current turn to wind down.
 *
 * DECISION: hook `input`, not `registerShortcut("enter", ...)`.
 * "enter" is already bound to the built-in `tui.input.submit` action
 * (see docs/keybindings.md), and registerShortcut's type signature has no
 * priority/scope field to say "run before/instead of the built-in editor
 * binding" - keybindings.md's only precedence note is about explicit
 * *editor* bindings (ctrl+p history) beating *app-level* actions while
 * focused, which doesn't clearly resolve whether a second registerShortcut
 * on the SAME key as an existing app-level action even fires. `input`
 * fires on every submitted message regardless of how it got submitted, and
 * comes with `event.streamingBehavior` telling us directly whether this
 * submission is being treated as a mid-stream steer - no key-precedence
 * guessing required.
 *
 * MECHANICS:
 *  - event.streamingBehavior === "steer": this submission would normally
 *    queue behind the current turn (this is what plain Enter already does
 *    natively - the case this extension does NOT need to touch).
 *  - ctx.hasPendingMessages(): true if an EARLIER Enter already queued
 *    something we're still waiting on.
 *  - Both true at once means this is at least the second Enter during a
 *    busy turn - abort the current run and redeliver this text immediately
 *    instead of letting it join the queue behind the (now-aborted) turn.
 *
 * UNVERIFIED - flagging clearly since this could not be live-tested (see
 * pi/TODO's Longer TODOs "review vendored/hand-written extensions" note):
 *  - Whether ctx.hasPendingMessages() reflects state from BEFORE this
 *    input event's own message is enqueued, or after. Written assuming
 *    "before" (i.e. it only reports EARLIER queued messages) - if that's
 *    wrong, this fires on the very first Enter instead of the second.
 *  - Whether ctx.abort() leaves the agent idle in time for the immediate
 *    pi.sendUserMessage() call below to be treated as a fresh (non-steer)
 *    message. If abort() is async-but-not-fully-settled, sendUserMessage
 *    might throw ("must specify deliverAs while streaming").
 *  - Only handles plain text (event.images is ignored/dropped on the
 *    interrupt path) - acceptable gap for a first pass, not for later.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
	pi.on("input", async (event, ctx) => {
		// Only care about messages actually typed into the editor - not RPC
		// calls or messages injected by other extensions via sendUserMessage.
		if (event.source !== "interactive") return { action: "continue" };

		const isSecondEnterDuringBusyTurn = event.streamingBehavior === "steer" && ctx.hasPendingMessages();

		if (!isSecondEnterDuringBusyTurn) {
			// First Enter during a busy turn (or not busy at all) - let pi's
			// native queueing/immediate-send behavior handle it unchanged.
			return { action: "continue" };
		}

		await ctx.abort();

		// Re-deliver as a fresh message now that the run is aborted, rather
		// than trusting the original queued-steer delivery to "catch up" -
		// see the UNVERIFIED note above for why this explicit resend exists
		// instead of just letting { action: "continue" } fall through.
		pi.sendUserMessage(event.text);

		return { action: "handled" };
	});
}
