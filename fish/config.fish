### SETUP VARIABLES
set -x INSTALL "$HOME/.config"
set -x DOTFILES "$INSTALL/dotfiles"
set -x FISH_SCRIPTS "$DOTFILES/fish"
set -x XDG_CACHE_HOME "$HOME/.local/cache"
set -x TERM xterm-ghostty
set -x MANPAGER "less --use-color"
set -x PAGER bat
set -x EDITOR nvim

### COSMETIC SETTINGS
# Prompt init is available as fish_prompt autoloading function.
# Titles are set via the fish_title.fish function file.

set fish_greeting  # We do not need fish greeting us on every shell

### HISTORY SETTINGS
# TODO: Export atuin config file location here.
# TODO: Disable fish writing history
source "$FISH_SCRIPTS/atuin.fish"  # Moved to script for perf reasons

source "$FISH_SCRIPTS/history-search.fish"

### SHELL ALIASES
source "$FISH_SCRIPTS/scripts.fish"

### ZOXIDE Init
function __zoxide_hook --on-variable PWD # Store the pwd on every file change.
     command zoxide add -- (builtin pwd -L)
end
# Rest of the init is available as `z` and `zi` autoloading function

### Keybindings
bind ctrl-c cancel-commandline  # This leaves the previous commandline in place so we can refer to it.

# vim: ft=fish
