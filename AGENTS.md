# Dotfiles Repository Context

This repository contains the configuration files (dotfiles) for the user's development environment.

## 📁 Repository Structure & Scope

### Active Configurations
- **Fish Shell:** `fish/`
- **Ghostty:** `ghostty/`
- **Neovim (Vim):** `vim/`
- **Tmux:** `tmux/`
- **Shell Applications:** `shell_applications/` (e.g., Atuin, Eza)

### Retired & Archive
- **Archive Folder:** `archive/` contains retired services. **Ignore this folder** unless specifically requested. Do not delete its contents.
- **Deletions:** Small config deletions within active services (e.g., in `vim/` or `fish/`) are handled via Git history and do not move to `archive/`.

### Metadata & Maintenance
- **Versions:** `versions.json` tracks software versions (e.g., Neovim, Fish). Report any discrepancies between reality and this file.
- **TODOs:** Proactively investigate and address `TODO` comments encountered in active configurations. Ignore `TODO`s in `archive/`.

---

## 🎨 Design & Consistency

### Uniform Color Scheme
Themes live in `themes/`, one self-contained bundle per theme (`flexoki/`,
`tokyonight/`). Each application reads a symlink pointing into the active
bundle. **See `themes/README.md`** for how switching works and where every
symlink goes — read it before touching any colour or theming a new application.
`themes/flexoki/README.md` is the Flexoki palette reference.

A colour change goes in **every** bundle, not just the active one, and the
bundles must keep an identical key set — switching re-sources one theme over
another in a live shell, so any key a bundle omits silently keeps the previous
theme's value.

Each bundle has one file per application:
- **Neovim:** `nvim.lua` — the colorscheme plugin, and the LuaLine theme with it.
- **Fish Shell:** `fish.fish` — syntax highlighting, pager, *and* prompt colours.
- **Tmux:** `tmux.conf` — palette only; `tmux/theme.tmux` holds the structure.
- **Ghostty:** `ghostty`
- **Atuin History UI:** `atuin.toml`
- **eza:** `eza.yml`

The rule that keeps getting broken, for Flexoki: **dark mode uses the 400
level, light mode uses 600.** A 600-level colour on the dark background is the
light-mode palette in the wrong place, and usually fails contrast.

---

## 🛠 Application Specifics

### Neovim
- **Plugin Source:** Plugin code is located at `~/.local/share/nvim/site/pack/core/opt`. Reference it for debugging or understanding breakages.
- **Validation:** Always validate LuaLine configuration using the `:LuaLineNotices` command.
- **Validation:** Always lint the code at the end.

### Ghostty
- **Validation:** If Ghostty is installed, run `ghostty +validate-config` to verify changes.
- **Syntax Rule:** **No inline comments.** A line can contain either a configuration option or a comment, but never both.

---

## 🚀 Development Workflow

### Commit Standard
Keep commits small, focused, and single-purpose. Use the following prefix conventions:
- `[<application>]`: For changes to a specific application (e.g., `[vim]`, `[fish]`).
- `[shell_applications][<application>]`: For changes within the `shell_applications/` directory (e.g., `[shell_applications][atuin]`).
- `[meta]`: For repository-level changes (e.g., updating `versions.json`, `AGENTS.md`, or `.gitignore`).

### Local & Work Overrides
- **Privacy:** Never commit work-specific or private configurations.
- **Plugin Architecture:** For major services (Fish, Neovim), use a plugin-based approach to load uncommitted local files (e.g., company-specific configs). Maintain this pattern for any new major services.
