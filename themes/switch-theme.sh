#!/usr/bin/env bash
# Switch the active dotfiles theme, or check theme bundles for completeness.
# The switch itself is just re-pointing the symlinks documented in
# themes/README.md — this script exists so that step doesn't have to be
# copy-pasted by hand, and so a new theme or application can be validated
# before it's relied on.
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_dir="$(dirname "$script_dir")"
themes_dir="$script_dir"

# One entry per themed application: "<bundle file>|<symlink path>". All six
# symlinks live in the repo; the apps that need a path outside it (atuin,
# eza) get there via their own stable, one-time symlink — see
# themes/README.md — so switching never has to touch $HOME.
required_files=(fish.fish tmux.conf ghostty nvim.lua eza.yml atuin.toml)
links=(
    "fish.fish|$repo_dir/fish/theme.fish"
    "tmux.conf|$repo_dir/tmux/palette.tmux"
    "ghostty|$repo_dir/ghostty/theme"
    "nvim.lua|$repo_dir/vim/theme.lua"
    "eza.yml|$repo_dir/shell_applications/eza_theme.yml"
    "atuin.toml|$repo_dir/shell_applications/atuin_theme.toml"
)

usage() {
    cat <<EOF
Usage: $(basename "$0") <theme>     Switch to <theme>
       $(basename "$0") --list      List available themes, marking the active one
       $(basename "$0") --current   Print the active theme's name
       $(basename "$0") --check     Verify every bundle has all required files

Themes live in $themes_dir/<name>/. Adding one? Copy an existing bundle so
the file set matches, then run --check before switching to it. Adding an
application? Add its file to \$required_files and \$links above, add it to
every existing bundle, then run --check.
EOF
}

list_themes() {
    local d
    for d in "$themes_dir"/*/; do
        [[ -d "$d" ]] && basename "$d"
    done | sort
}

current_theme() {
    local target
    target=$(readlink "$repo_dir/fish/theme.fish" 2>/dev/null) || { echo "none"; return; }
    basename "$(dirname "$target")"
}

cmd_list() {
    local active
    active=$(current_theme)
    while IFS= read -r name; do
        if [[ "$name" == "$active" ]]; then
            echo "* $name"
        else
            echo "  $name"
        fi
    done < <(list_themes)
}

cmd_check() {
    local ok=1
    while IFS= read -r name; do
        for f in "${required_files[@]}"; do
            if [[ ! -e "$themes_dir/$name/$f" ]]; then
                echo "MISSING: themes/$name/$f"
                ok=0
            fi
        done
        local bf f
        for bf in "$themes_dir/$name"/*; do
            [[ -f "$bf" ]] || continue
            f=$(basename "$bf")
            [[ "$f" == "README.md" ]] && continue
            if [[ ! " ${required_files[*]} " == *" $f "* ]]; then
                echo "UNEXPECTED: themes/$name/$f (not in required_files — add it there if it's real)"
                ok=0
            fi
        done
    done < <(list_themes)

    if [[ "$ok" == 1 ]]; then
        echo "All bundles have the required ${#required_files[@]} files."
    else
        exit 1
    fi
}

cmd_switch() {
    local theme="$1"
    if [[ ! -d "$themes_dir/$theme" ]]; then
        echo "No such theme: $theme" >&2
        echo "Available: $(list_themes | tr '\n' ' ')" >&2
        exit 1
    fi
    for f in "${required_files[@]}"; do
        if [[ ! -e "$themes_dir/$theme/$f" ]]; then
            echo "themes/$theme/$f is missing — refusing to switch. Run --check for the full picture." >&2
            exit 1
        fi
    done

    for entry in "${links[@]}"; do
        local bundle_file="${entry%%|*}"
        local link="${entry##*|}"
        local target
        case "$link" in
            "$repo_dir"/*)
                # In-repo links use a relative target so the repo still
                # works if it's moved (see themes/README.md).
                target="../themes/$theme/$bundle_file"
                ;;
            *)
                target="$repo_dir/themes/$theme/$bundle_file"
                ;;
        esac
        mkdir -p "$(dirname "$link")"
        ln -sfn "$target" "$link"
    done

    if tmux info &>/dev/null; then
        tmux source-file "$repo_dir/tmux/tmux.conf"
        echo "tmux: reloaded"
    fi

    echo "Switched to $theme."
    echo "  fish:    run 'source \$DOTFILES/fish/theme.fish' in open shells"
    echo "  ghostty: reload config (default keybind: super+shift+comma)"
    echo "  eza, atuin, neovim: pick it up on next invocation/launch"
}

case "${1:-}" in
    -h|--help|"") usage ;;
    --list) cmd_list ;;
    --current) current_theme ;;
    --check) cmd_check ;;
    -*)
        echo "Unknown option: $1" >&2
        usage >&2
        exit 1
        ;;
    *) cmd_switch "$1" ;;
esac
