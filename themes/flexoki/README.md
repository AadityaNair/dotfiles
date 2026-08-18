# Flexoki — palette reference

The palette behind this bundle, [Flexoki](https://stephango.com/flexoki), dark
variant. Read this before touching any colour in `themes/flexoki/`, or before
theming a new application with it.

For how switching works and where each file is symlinked, see
[`../README.md`](../README.md).

## The one rule that keeps getting broken

**Dark mode uses the 400 level. Light mode uses the 600 level.**

Flexoki publishes 13 levels per hue. The 600 level is what a *light* theme uses
for coloured text on paper; on a near-black background it renders muddy and
frequently fails contrast. At one point tmux, eza and the fish prompt were all
using 600 while the fish theme next to them correctly used 400 — the status
bar's current-window indicator sat at 2.93:1, below even the 3:1 large-text
floor.

If a colour looks dull against the background, check whether it's a 600.

## Palette — dark variant

Accents (the 400 level):

| Slot | Hex | | Slot | Hex |
|---|---|---|---|---|
| `re` red | `#D14D41` | | `cy` cyan | `#3AA99F` |
| `or` orange | `#DA702C` | | `bl` blue | `#4385BE` |
| `ye` yellow | `#D0A215` | | `pu` purple | `#8B7EC8` |
| `gr` green | `#879A39` | | `ma` magenta | `#CE5D97` |

Base tones:

| Slot | Hex | Use |
|---|---|---|
| `bg` | `#100F0F` | background |
| `bg-2` | `#1C1B1A` | sidebar / panel background |
| `ui` | `#282726` | subtle UI, cursorline |
| `ui-2` | `#343331` | medium UI |
| `ui-3` | `#403E3C` | strong UI, bright black |
| `tx-3` | `#575653` | comments, faint text |
| `tx-2` | `#878580` | dimmed text |
| `tx` | `#CECDC3` | primary text |

The base ramp has a finer grain than the three named text tones above — the
full spec runs `50/100/150/200(tx)/300/400/500(tx-2)/600/700(tx-3)/800(ui-3)/850(ui-2)/900(ui)/950(bg-2)`.
`tx-3` and `tx-2` are for genuine de-emphasis (comments, borders). They read as
much too dark for anything a user is actually meant to read — a "dim" or
"secondary" style applied to real body content (help text, tool output, code
blocks). Pi leans on exactly that pattern (its `"dim"` style alone backs 38
call sites: onboarding hints, the model list, resource summaries), and the
first pass at that theme mapped `dim`/`muted` straight to `tx-3`(700)/`tx-2`(500)
— 2.6:1 and 5.2:1 — which read as barely-there. Fixed by walking every text
tone up one full ramp step so each still reads as *relatively* muted but stays
legible: `fg`→200 (11.98:1), `fgDark`→300 (9.31:1), `fgGutter`("dim")→400
(7.05:1), `comment`("muted"/borders)→500 (5.19:1). Check what a "muted"-style
colour actually renders (not just borders/punctuation) before assuming `tx-3`
is safe — count call sites if the app's source is available.

Other tiers, when a plain accent isn't enough — brighter for emphasis, or a tint
to sit *behind* text:

| Tier | Level | Example (blue) |
|---|---|---|
| `X-3` bright / emphasis | 300 | `#66A0C8` |
| `X-2` dim / secondary | 600 | `#205EA6` |
| `X-bg` subtle tint | 950 | `#101A24` |
| `X-bg-2` stronger tint | 900 | `#12253B` |

Full spec (all 119 values, both variants):
<https://github.com/kepano/flexoki/blob/main/css/flexoki.css>. Generate from that
file rather than transcribing — two published sources disagree on `green-200`.

Neovim's colorscheme is a separate repo, `AadityaNair/flexoki-neovim`; its
`CONTEXT.md` documents the palette and semantic slots in depth.

## Rules

1. Take colours from the tables above. Accents at 400, greys from the base ramp.
2. **Annotate each value with its slot** (`# bl`, `# tx-2`). The applications
   that skipped this are exactly the ones that drifted to 600 unnoticed.
3. Never use `bg` (`#100F0F`) as a *foreground*. It's invisible, not muted —
   eza had two entries doing this. Muted is `tx-3`.

## Verifying

Most of these fail silently, so check the rendered output rather than trusting
the file. To decode what a program actually emitted:

```sh
<command> | cat -v | grep -oE '38;2;[0-9]+;[0-9]+;[0-9]+' | sort -u
```

`38;2;R;G;B` is truecolor foreground; convert to hex to confirm the level.

| App | Check |
|---|---|
| tmux | `tmux -L check -f /dev/null new-session -d && tmux -L check source-file $PWD/tmux/theme.tmux` — then `tmux -L check show -gv @background-active`. Kill with `tmux -L check kill-server`. Exit status matters: an empty slot gives `invalid style: fg=,bg=`. |
| Fish | `fish -c 'echo $fish_color_command'` in a *fresh* shell. Then `fish -n fish/functions/fish_prompt.fish` and exercise every prompt segment — cwd, git branch, exit status, duration — and decode. |
| Ghostty | `ghostty +validate-config` (silent, exit 0), then `ghostty +show-config \| grep '^palette'`. Explicit `palette =` lines override `theme`. Note that ghostty ignores *unknown* keys silently, so validation passing does not prove a key exists. |
| eza | `eza --color=always -l <dir>` and decode. Needs an explicit directory argument. |
| atuin | `atuin info` — it prints `WARN Could not load theme <name>` on any subcommand when the theme is missing or malformed. Silence means it loaded. Atuin resolves themes by *filename*; the `[theme] name` inside the file is required to exist but is never compared to it. |
| Neovim | `nvim --headless -c 'lua print(vim.g.colors_name)' -c qa`, then diff sorted `:highlight` dumps. See `CONTEXT.md` in the colorscheme repo. |

For contrast, WCAG AA is 4.5:1 for body text and 3:1 for large text. Worth
checking any colour used as a *background* behind dark text.

## Known upstream issue: Ghostty's bundled theme

Ghostty's *Flexoki Dark* maps normal ANSI to the 400 level but bright (9–14) to
600, so every bright colour is **darker** than its normal counterpart — bright
magenta lands at 2.85:1. This is upstream's bug, not a local misconfiguration.

`bold-is-bright` used to be set here to work around it, and was then removed
because it promoted bold text into that inverted half, rendering bold *dimmer*
than regular text. The key no longer exists at all as of Ghostty 1.3.2 — it is
absent from all 300 keys in `ghostty +show-config` — so it had quietly become a
no-op. `bold-color` is its replacement.

Everyday tools emit normal ANSI rather than bright — git, ls and grep all use
31/32/34, not 91/92/94 — so the inverted half is rarely reached. If it ever does
bite, overriding all 16 `palette =` entries to normal=400 / bright=300 fixes it
and matches what Neovim sets for `terminal_color_0..15`.
