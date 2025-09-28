# A first draft custom implementation of fish prompt without starship.
# The only two advantages is:
#   1. Lower dependency
#   2. OSC 133 support useful for tmux

# I don't see only slight perf improvements (500ms) with only this.
# It will get worse as we add more components (ie git, jobs, colour)
# So, I am wondering if it is even worth it.

# Leaving it here for future improvements.

function fish_prompt
    set -l status_orig $status
    set -l pwd (prompt_pwd -D 3)

    set -l cmd_prompt ""
    set -l status_prompt ""

    if test $CMD_DURATION -ge 2000
        set cmd_prompt "$(math --scale 0 $CMD_DURATION/1000)s >"
    end

    if test $status_orig -ne 0
        set status_prompt "X $status_orig >"
    end

    echo "$pwd > $cmd_prompt $status_prompt"

end
