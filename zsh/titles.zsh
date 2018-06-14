# Nair's tmux titles.
# Use on your own risk

# Print truncated current path

trunc_path() {
    DIR_LENGTH=2
    DELIMITER='..'
    echo $(print -P "%$((DIR_LENGTH+1))(c:$DELIMITER/:)%${DIR_LENGTH}c")
}

# Set the title once when a new shell is created.

tmux_rename() {
    # TODO: Remove the hardcode
    \tmux -S /tmp/tmux-1000/default rename-window $1
}

tmux_rename $(trunc_path)


function zsh_change_title() {
    tmux_rename $(trunc_path)
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd zsh_change_title
