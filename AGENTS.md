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
Maintain visual consistency across all services. When updating themes or colors, ensure synchronized updates for:
- **Neovim:** Including UI-generating plugins (e.g., LuaLine).
- **Fish Shell**
- **Tmux**
- **Ghostty**
- **Atuin History UI**

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
