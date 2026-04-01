# Pure fish prompt — no external dependencies.

# Tokyo Night palette
set -g __prompt_c_yellow e0af68
set -g __prompt_c_cyan 2ac3de
set -g __prompt_c_red f7768e
set -g __prompt_c_orange ff9e64

function __prompt_directory
    set -l cwd (string replace -- $HOME '~' $PWD)
    set -l parts
    for p in (string split -- '/' $cwd)
        test -n "$p"; and set -a parts $p
    end
    if test (count $parts) -gt 3
        set cwd '…/'(string join '/' $parts[-3..-1])
    end
    set_color $__prompt_c_yellow
    printf ' %s ❯' $cwd
end

function __prompt_git
    # Walk up to find .git before spawning git.
    # On some hosts, `git` takes ~600ms just to start, even outside a repo.
    # This walk costs <1ms and avoids that entirely.
    set -l d $PWD
    while test "$d" != /
        if test -d "$d/.git" -o -f "$d/.git"
            set -l git_out (command git status --porcelain=v1 --branch 2>/dev/null)
            test -n "$git_out"; or return

            set_color $__prompt_c_cyan

            # Branch name from header: "## main...origin/main [ahead 1]"
            set -l header $git_out[1]
            set -l branch (string replace -- '## ' '' $header | string split -- '...' )[1]
            if string match -q '## HEAD*' -- $header
                set branch (command git rev-parse --short HEAD 2>/dev/null)
            else if string match -q '*No commits yet*' -- $header
                set branch (string replace -- '## No commits yet on ' '' $header)
            end
            printf ' %s' $branch

            # Status indicators from file lines
            set -l ind ''
            set -l has_staged 0
            set -l has_modified 0
            set -l has_untracked 0
            for line in $git_out[2..-1]
                if test $has_staged -eq 1 -a $has_modified -eq 1 -a $has_untracked -eq 1
                    break
                end
                set -l x (string sub -l 1 -- $line)
                set -l y (string sub -s 2 -l 1 -- $line)
                if test $has_staged -eq 0; and contains -- $x A M R D C
                    set has_staged 1; set ind $ind'+'
                end
                if test $has_modified -eq 0; and contains -- $y M D
                    set has_modified 1; set ind $ind'!'
                end
                if test $has_untracked -eq 0; and test "$x$y" = '??'
                    set has_untracked 1; set ind $ind'?'
                end
            end

            # Ahead/behind from header
            set -l m (string match -r -- 'ahead (\d+)' $header)
            test $status -eq 0; and set ind $ind"⇡$m[2]"
            set m (string match -r -- 'behind (\d+)' $header)
            test $status -eq 0; and set ind $ind"⇣$m[2]"

            if test -n "$ind"
                printf ' %s' $ind
            end
            printf ' ❯'
            return
        end
        set d (path dirname "$d")
    end
end

function __prompt_exit_status --argument-names last_status
    if test $last_status -ne 0
        set_color $__prompt_c_red
        printf ' %s ❯' $last_status
    end
end

function __prompt_duration --argument-names duration
    if test -n "$duration"; and test "$duration" -gt 2000
        set -l secs (math --scale=0 "$duration / 1000")
        set_color $__prompt_c_orange
        if test $secs -ge 3600
            printf ' %dh%dm%ds ❯' (math --scale=0 "$secs / 3600") (math --scale=0 "$secs % 3600 / 60") (math --scale=0 "$secs % 60")
        else if test $secs -ge 60
            printf ' %dm%ds ❯' (math --scale=0 "$secs / 60") (math --scale=0 "$secs % 60")
        else
            printf ' %ds ❯' $secs
        end
    end
end

function fish_prompt
    # Capture before anything overwrites them.
    set -l last_status $status
    set -l duration $CMD_DURATION

    __prompt_directory
    __prompt_git
    __prompt_exit_status $last_status
    __prompt_duration $duration

    set_color normal
    printf ' '
end
