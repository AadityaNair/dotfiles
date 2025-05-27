if status is-interactive
    ### SETUP VARIABLES
    set -x INSTALL "$HOME/.config"
    set -x XDG_CACHE_HOME "$HOME/.local/cache"
    set -x TERM "tmux-256color"
    set -x MANPAGER "bat -l man -p" # TODO: Find a better manpager
    set -x EDITOR "nvim"


    ### COSMETIC SETTINGS
    set -x STARSHIP_CONFIG "$INSTALL/dotfiles/zsh/starship.toml"
    starship init fish | source
    # TODO: Configure titles

    ### HISTORY SETTINGS
    # TODO: Export atuin config file location here.
    # TODO: Add function for the up arrow function.
    atuin init fish | source

    ### AUTOCOMPLETE SETTINGS

    ### SHELL ALIASES
    source "$INSTALL/dotfiles/archive/fish/scripts.fish"

    ### OTHERS
    zoxide init fish | source
    # TODO: Configure zoxide
end
 # vim: ft=fish
