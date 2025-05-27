# Custom titles for fish shell.

# The documentation: https://fishshell.com/docs/current/cmds/fish_title.html
# You won't get from reading the documentation but you can actually differentiate
# between when this command is run before or after an actual command.
# Before the command run $argv[1] is the command itself
# After the command run $argv[1] is `fish`

function rename
end

if test -n "$ZELLIJ"
    function rename
        zellij action rename-tab "$argv[1]"
    end
else if test -n "$TMUX"
    function rename
        printf "\033k%s\033\\" "$argv[1]"
    end
end

# TODO: Fully build this function
function fish_title
end

