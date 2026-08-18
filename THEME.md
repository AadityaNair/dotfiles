# Theme reference — Flexoki

Every themed application here uses [Flexoki](https://stephango.com/flexoki), dark
variant. This file is the shared reference so a new application can be themed
without re-deriving the palette or rediscovering how each config is installed.

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

## Where each theme lives

| App | File | Installed as | Format |
|---|---|---|---|
| Neovim | *(external)* `AadityaNair/flexoki-neovim` | `~/.config/nvim` → `vim/` | Lua plugin |
| tmux | `tmux/theme.tmux` | sourced by `tmux/tmux.conf` | `set -g @name '#RRGGBB'` |
| Fish syntax | `fish/themes/flexoki_dark.theme` | `~/.config/fish/themes` → dir symlink | `key rrggbb` (no `#`) |
| Fish prompt | `fish/functions/fish_prompt.fish` | `~/.config/fish/functions` → dir symlink | `set -g __prompt_c_* RRGGBB` |
| Ghostty | `ghostty/config` | `~/.config/ghostty/config` | `theme = Flexoki Dark` |
| eza | `shell_applications/eza_theme.yml` | `~/.config/eza/theme.yml` | YAML, `"#RRGGBB"` |
| atuin | `shell_applications/atuin_theme.toml` | `~/.config/atuin/themes/flexoki_dark.toml` | TOML, `"#RRGGBB"` |
| Pi (coding agent) | `pi/themes/flexoki.json` | `$PI_CODING_AGENT_DIR/themes` (`~/.local/share/pi/agent/themes`) → dir symlink; `"theme"` in `pi/settings.json` | JSON, `vars`/`colors`/`export` |

Neovim's colorscheme is a separate repo; its `CONTEXT.md` documents the palette
and semantic slots in depth.

## Adding a new application

1. Take colours from the tables above. Accents at 400, greys from the base ramp.
2. **Annotate each value with its slot** (`# bl`, `# tx-2`). The apps that
   skipped this are exactly the ones that drifted to 600 unnoticed.
3. Never use `bg` (`#100F0F`) as a *foreground*. It's invisible, not muted —
   eza had two entries doing this. Muted is `tx-3`.
4. If the app installs via symlink, check the **filename** matches what the
   config asks for. atuin silently fell back to its built-in default for months
   because `config.toml` requested `flexoki_dark` while the symlink was still
   called `tokyonight.toml`.
5. Verify (below), then commit with the `[app]` prefix from `AGENTS.md`.

## Verifying

Most of these fail silently, so check the rendered output rather than trusting
the file. To decode what a program actually emitted:

```sh
<command> | cat -v | grep -oE '38;2;[0-9]+;[0-9]+;[0-9]+' | sort -u
```

`38;2;R;G;B` is truecolor foreground; convert to hex to confirm the level.

| App | Check |
|---|---|
| tmux | `tmux -L check -f /dev/null new-session -d && tmux -L check source-file $PWD/tmux/theme.tmux` — then `tmux -L check show -gv @background-active`. Kill with `tmux -L check kill-server`. |
| Fish | `fish -n fish/functions/fish_prompt.fish`, then run each prompt segment and decode. Exercise all paths: cwd, git branch, exit status, duration. |
| Ghostty | `ghostty +validate-config`, then `ghostty +show-config \| grep '^palette'` for the effective palette. Explicit `palette =` lines override `theme`. |
| eza | `eza --color=always -l <dir>` and decode. Needs an explicit directory argument. |
| atuin | No headless check — its TUI won't render under `script`, and it falls back silently on a missing theme, so "no error" proves nothing. Confirm the TOML parses and eyeball it with the up-arrow. |
| Neovim | See `CONTEXT.md` in the colorscheme repo — diff sorted `:highlight` dumps. |

For contrast, WCAG AA is 4.5:1 for body text and 3:1 for large text. Worth
checking any colour used as a *background* behind dark text.

## Known upstream issue: Ghostty's bundled theme

Ghostty's *Flexoki Dark* maps normal ANSI to the 400 level but bright (9–14) to
600, so every bright colour is **darker** than its normal counterpart — bright
magenta lands at 2.85:1. This is upstream's bug, not a local misconfiguration.

`bold-is-bright` is therefore deliberately unset: it promoted bold text into that
inverted half, rendering bold *dimmer* than regular text. (It's also deprecated
since Ghostty 1.2.0 in favour of `bold-color`.)

Everyday tools emit normal ANSI rather than bright — git, ls and grep all use
31/32/34, not 91/92/94 — so with `bold-is-bright` gone the inverted half is
rarely reached. If it ever does bite, overriding all 16 `palette =` entries to
normal=400 / bright=300 fixes it and matches what Neovim sets for
`terminal_color_0..15`.
