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
Everything themed here uses **Flexoki**, dark variant. **See `THEME.md`** for the
palette, where each application's theme lives, and how to verify one — read it
before touching any colour or theming a new application.

The rule that keeps getting broken: **dark mode uses the 400 level, light mode
uses 600.** A 600-level colour on the dark background is the light-mode palette
in the wrong place, and usually fails contrast.

When updating themes or colors, ensure synchronized updates for:
- **Neovim:** Including UI-generating plugins (e.g., LuaLine).
- **Fish Shell:** Both the syntax theme and the prompt — they are separate files.
- **Tmux**
- **Ghostty**
- **Atuin History UI**
- **eza**

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
