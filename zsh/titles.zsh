# Nair's tmux titles.
# Use on your own risk
#
# NOTE: We could have used chpwd to print pwd but we still needed to change title after 
# any command was executed. That required using precmd and that seemed to fulfill the 
# chpwd task as well.


tmux_rename() {
    printf "\033k$1\033\\"
}

# Print truncated current path
trunc_path() {
    DIR_LENGTH=2
    DELIMITER='..'
    echo $(print -P "%$((DIR_LENGTH+1))(c:$DELIMITER/:)%${DIR_LENGTH}c")
}

function set_pwd() {
    tmux_rename $(trunc_path)
}

function set_from_command(){
    local -a cmd
    cmd=(${(z)1}) # Convert command string to a list of words.

    case $cmd[1] in
        vim) tmux_rename "◉ $cmd[2]" ;;
        man|run-help) tmux_rename "$cmd[2] ❓" ;;
        ssh) tmux_rename "$cmd[2]" ;;
        *) tmux_rename "$cmd[1]" ;;
    esac
}


autoload -Uz add-zsh-hook

add-zsh-hook precmd set_pwd
add-zsh-hook preexec set_from_command
