### SETUP VARIABLES
set -x INSTALL "$HOME/.config"
set -x XDG_CACHE_HOME "$HOME/.local/cache"
set -x TERM tmux-256color
set -x MANPAGER "bat -l man -p" # TODO: Find a better manpager
set -x PAGER bat
set -x EDITOR nvim


### COSMETIC SETTINGS
set -x STARSHIP_CONFIG "$INSTALL/dotfiles/shell_applications/starship.toml"
starship init fish | source # TODO: Init is costly and contains useless functions. Investigate caching.

source "$INSTALL/dotfiles/archive/fish/titles.fish"

### HISTORY SETTINGS
# TODO: Export atuin config file location here.
# TODO: Disable fish writing history
atuin init fish --disable-up-arrow | source # TODO: Doing init is costly. Investigate caching.

# TODO: Use atuin for up arrow function. Because this will only search fish history, which isn't much.
bind up history-prefix-search-backward
bind down history-prefix-search-forward

### SHELL ALIASES
source "$INSTALL/dotfiles/archive/fish/scripts.fish"

### NAVIGATION
# TODO: Set fzf options and theme for better fzf experience. Also consider using fzf for some things.
zoxide init fish | source # TODO: Doing init is costly. Investigate caching.

function sudo_prev
    set -l cur_buf (commandline)

    if test -n $cur_buf
        if not string match -q "sudo *" $cur_buf  # Only add sudo if it isnt already there.
            commandline "sudo $cur_buf"
        end
    else
        commandline "sudo $history[1]"
    end
end
bind escape,escape sudo_prev

function last_history_item
    echo $history[1]
end
abbr -a !! --position anywhere --function last_history_item

# TODO: backward-word
# TODO: forward-word
# TODO: delete-word
# TODO: insert last argument

# vim: ft=fish
