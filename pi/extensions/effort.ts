import type { ExtensionAPI, ExtensionCommandContext } from "@earendil-works/pi-coding-agent";
import type { AutocompleteItem } from "@earendil-works/pi-tui";

const EFFORT_LEVELS = ["off", "minimal", "low", "medium", "high", "xhigh", "max"] as const;
type EffortLevel = (typeof EFFORT_LEVELS)[number];

type ModelWithThinkingLevels = {
	reasoning?: boolean;
	thinkingLevelMap?: Partial<Record<EffortLevel, string | null>>;
};

function isEffortLevel(value: string): value is EffortLevel {
	return (EFFORT_LEVELS as readonly string[]).includes(value);
}

function getAvailableEffortLevels(ctx: ExtensionCommandContext): EffortLevel[] {
	const model = ctx.model as ModelWithThinkingLevels | undefined;
	if (!model?.reasoning) return ["off"];

	const map = model.thinkingLevelMap;
	return EFFORT_LEVELS.filter((level) => {
		const mapped = map?.[level];
		if (mapped === null) return false;

		// Standard levels use Pi's default provider mapping when omitted.
		// Extended levels must be explicitly enabled by the model.
		if (level === "xhigh" || level === "max") {
			return typeof mapped === "string";
		}
		return true;
	});
}

function applyEffort(pi: ExtensionAPI, ctx: ExtensionCommandContext, requested: EffortLevel): void {
	pi.setThinkingLevel(requested);
	const effective = pi.getThinkingLevel();
	const modelName = ctx.model ? `${ctx.model.provider}/${ctx.model.id}` : "the current model";

	if (!ctx.hasUI) return;

	if (effective !== requested) {
		ctx.ui.notify(
			`Effort ${requested} is unavailable for ${modelName}; using ${effective}.`,
			"warning",
		);
		return;
	}

	ctx.ui.notify(`Effort set to ${effective} for ${modelName}.`, "info");
}

export default function effortExtension(pi: ExtensionAPI): void {
	pi.registerCommand("effort", {
		description: "Change the current model's reasoning effort",
		getArgumentCompletions: (prefix: string): AutocompleteItem[] | null => {
			const normalized = prefix.trim().toLowerCase();
			const items = EFFORT_LEVELS.filter((level) => level.startsWith(normalized)).map((level) => ({
				value: level,
				label: level,
				description: `Set model reasoning effort to ${level}`,
			}));
			return items.length > 0 ? items : null;
		},
		handler: async (args, ctx) => {
			const raw = args.trim().toLowerCase();

			if (raw) {
				if (!isEffortLevel(raw)) {
					if (ctx.hasUI) {
						ctx.ui.notify(`Unknown effort level: ${raw}. Use: ${EFFORT_LEVELS.join(", ")}.`, "warning");
					}
					return;
				}

				applyEffort(pi, ctx, raw);
				return;
			}

			if (!ctx.hasUI) return;

			const current = pi.getThinkingLevel();
			const available = getAvailableEffortLevels(ctx);
			const ordered = [current, ...available.filter((level) => level !== current)];
			const selected = await ctx.ui.select(`Model effort (current: ${current})`, ordered);
			if (!selected || !isEffortLevel(selected)) return;

			applyEffort(pi, ctx, selected);
		},
	});
}
