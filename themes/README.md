# Themes

Two themes live here, `flexoki/` and `tokyonight/`. Each is a self-contained
bundle: one file per themed application, all named the same way across bundles.

| File | Application | Read by |
|---|---|---|
| `fish.fish` | fish syntax highlighting, pager, prompt | `fish/config.fish` |
| `tmux.conf` | tmux palette (`@`-variables only) | `tmux/theme.tmux` |
| `ghostty` | ghostty colours | `ghostty/config` |
| `nvim.lua` | neovim colorscheme + lualine | `vim/plugin/appearance.lua` |
| `eza.yml` | eza | `EZA_CONFIG_DIR`, via `~/.config/eza/theme.yml` |
| `atuin.toml` | atuin history UI | `shell_applications/atuin.toml`, via `~/.config/atuin/themes/current.toml` |

`flexoki/README.md` documents the Flexoki palette itself — read that before
touching any colour.

## How the switch works

Every application reads a **fixed path that is a symlink** into one of the
bundles. Nothing parses a config, forks a process, or branches on a variable at
startup; the indirection is a symlink, resolved by the kernel. The symlinks
*are* the state, so there is no separate file that can disagree with them.

All six symlinks live in the repo and are gitignored, because which theme is
active is a per-machine choice rather than something to commit:

| Symlink | Points at |
|---|---|
| `fish/theme.fish` | `../themes/<name>/fish.fish` |
| `tmux/palette.tmux` | `../themes/<name>/tmux.conf` |
| `ghostty/theme` | `../themes/<name>/ghostty` |
| `vim/theme.lua` | `../themes/<name>/nvim.lua` |
| `shell_applications/eza_theme.yml` | `../themes/<name>/eza.yml` |
| `shell_applications/atuin_theme.toml` | `../themes/<name>/atuin.toml` |

They all use relative targets, so the repo still works if it is moved.

eza and atuin insist on a fixed path outside the repo, so each gets one more
symlink pointing at its `shell_applications/` file above. Unlike the six,
these are per-machine **setup**, not part of switching — they don't change
when the theme does, so `switch-theme.sh` never touches them. Create them
once (`ln -sfn` also repoints, so re-running is harmless):

```fish
ln -sfn $DOTFILES/shell_applications/eza_theme.yml    ~/.config/eza/theme.yml
ln -sfn $DOTFILES/shell_applications/atuin_theme.toml ~/.config/atuin/themes/current.toml
```

## Switching

`themes/switch-theme.sh <name>` re-points every symlink in the table above at
`themes/<name>/`, creating them if they don't exist yet — so it's also the
install step on a fresh machine. It refuses to switch to a bundle that's
missing a required file rather than leave things half-themed.

```fish
themes/switch-theme.sh flexoki      # or tokyonight
themes/switch-theme.sh --list       # see what's available, and what's active
themes/switch-theme.sh --current    # print the active theme's name
source $DOTFILES/fish/theme.fish    # picks the new theme up in this shell
```

It reloads tmux itself (`tmux source-file`, if a server is running). Fish,
ghostty, eza, atuin, and neovim still need the steps in the table below —
the script prints them as a reminder after switching.

What updates when:

| | |
|---|---|
| tmux | immediately, from the `source-file` above |
| eza, atuin | next invocation |
| fish | the `source` above covers this shell; others on next launch |
| ghostty | needs its reload-config keybind (`super+shift+comma` by default) |
| neovim | new instances |

To see what is active: `readlink fish/theme.fish`.

## Degrading

Every read site is guarded, so a missing or dangling symlink leaves an
unthemed but working application rather than an error — a fresh clone starts
fine before any of this has been run. `fish` falls back to `set_color normal`,
`tmux` seeds every slot with `default`, `ghostty` uses the `?` optional-path
prefix, and `nvim` stats the file before loading it.

The one exception is atuin, which prints `WARN Could not load theme current` on
every invocation until its symlink exists. That is atuin's own behaviour and
cannot be suppressed while a theme is named in its config.

## Adding a theme

1. `mkdir themes/<name>` and add all six files. Copy an existing bundle to get
   the key coverage right rather than starting from an upstream theme file —
   see the note below.
2. Follow `flexoki/README.md` for palette discipline if the theme has a spec.
3. Run `themes/switch-theme.sh --check` — it verifies every bundle has all six
   required files (and flags any stray file that isn't one of them).
4. Switch to it with `themes/switch-theme.sh <name>` and verify — most of
   these fail silently, so check rendered output rather than trusting the
   file. `flexoki/README.md` has the per-application commands.

**Keep the key set identical across bundles.** The upstream fish themes did
not: TokyoNight set eight keys Flexoki did not, and Flexoki set three TokyoNight
did not. Because switching re-sources a theme over the top of the previous one
in a live shell, any key a bundle omits keeps the *old* theme's value. Both
bundles here now define the same 23 keys. `--check` only verifies file
presence, not key coverage inside a file — that part is still manual.

## Adding an application

1. Add a file to every existing bundle.
2. Add an in-repo symlink (`<app>/theme.<ext>`, or a file under
   `shell_applications/` if the app can't read the repo path directly), a
   `.gitignore` entry for it, and a read site in the application's config. If
   the app needs a fixed path outside the repo, point that path at the new
   in-repo symlink as one-time setup — see the eza/atuin example above —
   rather than having `switch-theme.sh` reach outside the repo.
3. Add the file to `required_files` and `links` at the top of
   `switch-theme.sh`, then run `themes/switch-theme.sh --check` to confirm
   every bundle actually has it.
