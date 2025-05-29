### SETUP VARIABLES
set -x INSTALL "$HOME/.config"
set -x XDG_CACHE_HOME "$HOME/.local/cache"
set -x TERM "tmux-256color"
set -x MANPAGER "bat -l man -p" # TODO: Find a better manpager
set -x PAGER "bat"
set -x EDITOR "nvim"


### COSMETIC SETTINGS
set -x STARSHIP_CONFIG "$INSTALL/dotfiles/shell_applications/starship.toml"
starship init fish | source
# TODO: Init is costly and contains useless functions. Try caching a partial output somewhere.

source "$INSTALL/dotfiles/archive/fish/titles.fish"

### HISTORY SETTINGS
# TODO: Export atuin config file location here.
# TODO: Add function for the up arrow function.
# TODO: Doing init here is costly. Investigate caching the output somewhere.
atuin init fish --disable-up-arrow | source

### SHELL ALIASES
source "$INSTALL/dotfiles/archive/fish/scripts.fish"

### NAVIGATION
# TODO: Set fzf options and theme for better fzf experience. Also consider using fzf for some things.
zoxide init fish | source  # TODO: init is costly. Investigate caching its output.
# TODO: Esc-Esc for sudo command
# TODO: All navigation keybindings
 # vim: ft=fish
