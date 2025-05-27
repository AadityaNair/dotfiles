if status is-interactive
    ### SETUP VARIABLES
    set -x INSTALL "$HOME/.config"
    set -x XDG_CACHE_HOME "$HOME/.local/cache"
    set -x TERM "tmux-256color"
    set -x MANPAGER "bat -l man -p" # TODO: Find a better manpager
    set -x EDITOR "nvim"


    ### COSMETIC SETTINGS
    set -x STARSHIP_CONFIG "$INSTALL/dotfiles/shell_applications/starship.toml"
    starship init fish | source
    # TODO: Small optimisation where we just directly save the fish_prompt function.
    #       And regenrate it whenever we update the starship theme.

    source "$INSTALL/dotfiles/archive/fish/titles.fish"

    ### HISTORY SETTINGS
    # TODO: Export atuin config file location here.
    # TODO: Add function for the up arrow function.
    atuin init fish --disable-up-arrow | source

    ### AUTOCOMPLETE SETTINGS

    ### SHELL ALIASES
    source "$INSTALL/dotfiles/archive/fish/scripts.fish"

    ### NAVIGATION
    zoxide init fish | source # TODO: Configure zoxide
    # TODO: Esc-Esc for sudo command
    # TODO: All navigation keybindings
end
 # vim: ft=fish
