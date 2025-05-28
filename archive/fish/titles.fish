# Custom titles for fish shell.

# The documentation: https://fishshell.com/docs/current/cmds/fish_title.html
# You won't get from reading the documentation but you can actually differentiate
# between when this command is run before or after an actual command.
# Before the command run $argv[1] is the command itself
# After the command run $argv[1] is "" (empty string)

function terminal_rename
end

if test -n "$ZELLIJ"
    function terminal_rename
        zellij action rename-tab "$argv[1]"
    end
else if test -n "$TMUX"
    function terminal_rename
        printf "\033k%s\033\\" "$argv[1]"
    end
end

function fish_title
    set -l cmd (string split ' ' "$argv[1]")
    set -l cnt (count $cmd)

    switch $cmd[1]

        case vim nvim
            set -l filename (path basename $cmd[2])
            terminal_rename "◉ $filename"

        case man run-help
            if test $cnt -eq 3
                terminal_rename "$cmd[3]($cmd[2]) ❓"
            else
                terminal_rename "$cmd[2] ❓"
            end

        case ssh
            terminal_rename "$cmd[2]"

        case sudo
            terminal_rename "⚡$cmd[2]"

        case ""  # After the command has run
            terminal_rename "$(prompt_pwd --full-length-dirs=1 --dir-length 2)"

        case *
            terminal_rename "$cmd[1]"
    end
end

