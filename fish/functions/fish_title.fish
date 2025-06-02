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
            terminal_rename "$cmd[-1]"

        case ssh
            terminal_rename "$cmd[2]"

        case sudo
            terminal_rename "⚡$cmd[2]"

        case "" # After the command has run
            terminal_rename "$(get_cwd)"
        case "*"
            terminal_rename "$(title_catchall $cmd)"
    end
end

# Make this into a custom function so that it can later be overridden.
function get_cwd
    if functions -q custom_get_cwd
        custom_get_cwd
    else
        prompt_pwd --full-length-dirs 1 --dir-length 2
    end
end

# Again, so that we can override it with company specific stuff.
function title_catchall
    if functions -q custom_title_catchall
        custom_title_catchall $argv
    else
        echo $argv[1]
    end
end

