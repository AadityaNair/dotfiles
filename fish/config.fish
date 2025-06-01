### SETUP VARIABLES
set -x INSTALL "$HOME/.config"
set -x DOTFILES "$INSTALL/dotfiles"
set -x FISH_SCRIPTS "$DOTFILES/fish"
set -x XDG_CACHE_HOME "$HOME/.local/cache"
set -x TERM tmux-256color
set -x MANPAGER "bat -l man -p" # TODO: Find a better manpager
set -x PAGER bat
set -x EDITOR nvim

### COSMETIC SETTINGS
set -x STARSHIP_CONFIG "$DOTFILES/shell_applications/starship.toml"
# Rest of the init is available as fish_prompt autoloading function.

source "$FISH_SCRIPTS/titles.fish"

function fish_greeting --description "We do not need fish greeting us on every shell"
end

### HISTORY SETTINGS
# TODO: Export atuin config file location here.
# TODO: Disable fish writing history
atuin init fish --disable-up-arrow | source # TODO: Doing init is costly. Investigate caching.

source "$FISH_SCRIPTS/history-search.fish"

### SHELL ALIASES
source "$FISH_SCRIPTS/scripts.fish"

### ZOXIDE Init
function __zoxide_hook --on-variable PWD # Store the pwd on every file change.
    test -z "$fish_private_mode"
    and command zoxide add -- (builtin pwd -L)
end
# Rest of the init is available as `z` and `zi` autoloading function


# Far future todo: Investigate if there is any advantage to splitting parts of code into
# autoloding functions. As of 31/05/25, there is very little. We could get much bigger gains
# if we just optimised init for atuin/starship/zoxide.

# vim: ft=fish
