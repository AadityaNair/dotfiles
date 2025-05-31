### SETUP VARIABLES
set -x INSTALL "$HOME/.config"
set -x DOTFILES "$INSTALL/dotfiles"
set -x FISH_SCRIPTS "$DOTFILES/fish"
set -x XDG_CACHE_HOME "$HOME/.local/cache"
set -x TERM tmux-256color
set -x MANPAGER "bat -l man -p" # TODO: Find a better manpager
set -x PAGER bat
set -x EDITOR nvim

# TODO: Also investigate splitting config.fish into multiple files.

### COSMETIC SETTINGS
set -x STARSHIP_CONFIG "$DOTFILES/shell_applications/starship.toml"
starship init fish | source # TODO: Init is costly and contains useless functions. Investigate caching.

source "$FISH_SCRIPTS/titles.fish"

# No need for fish greeting inside tmux.
if test -n "$TMUX"; or test -n "$ZELLIJ"
    function fish_greeting
    end
end

### HISTORY SETTINGS
# TODO: Export atuin config file location here.
# TODO: Disable fish writing history
atuin init fish --disable-up-arrow | source # TODO: Doing init is costly. Investigate caching.

source "$FISH_SCRIPTS/history-search.fish"

### SHELL ALIASES
source "$FISH_SCRIPTS/scripts.fish"

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

# TODO: Unable to bind alt-. for some reason. Pls fix.
bind alt-/ forward-word
bind alt-comma backward-word
bind alt-i history-token-search-backward
# We already do alt/ctrl+backspace to kill word

# Far future todo: Investigate if there is any advantage to splitting parts of code into
# autoloding functions. As of 31/05/25, there is very little. We could get much bigger gains
# if we just optimised init for atuin/starship/zoxide.

# vim: ft=fish
