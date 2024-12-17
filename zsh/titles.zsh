# Nair's tmux titles.
# Use on your own risk
#
# NOTE: We could have used chpwd to print pwd but we still needed to change title after
# any command was executed. That required using precmd and that seemed to fulfill the
# chpwd task as well.





if [[ -n "$TMUX" ]]; then
    function rename() {
        printf "\033k%s\033\\" "$1"
    }

elif [[ -n "$ZELLIJ" ]]; then
    function rename() {
        zellij action rename-tab "$1"
    }

else
    function rename() {}

fi

# Print truncated current path
trunc_path() {
    DIR_LENGTH=2
    DELIMITER='..'
    print -P "%$((DIR_LENGTH+1))(c:$DELIMITER/:)%${DIR_LENGTH}c"
}

function set_pwd() {
    rename "$(trunc_path)"
}

function set_from_command(){
    local -a cmd
    cmd=(${(z)1}) # Convert command string to a list of words.

    case ${cmd[1]} in
        vim|nvim) rename "◉ ${cmd[2]}" ;;
        man|run-help) rename "${cmd[-1]} ❓" ;;
        ssh) rename "${cmd[2]}" ;;
        sudo) rename "⚡${cmd[2]}" ;;
        *) rename "${cmd[1]}" ;;
    esac
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd set_pwd
add-zsh-hook preexec set_from_command
