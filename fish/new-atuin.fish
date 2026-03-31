
# This basically maintains a single session for the entire shell session within tmux.
# TODO: There is probably a cheaper way to do this.
if not set -q ATUIN_SESSION; or test "$ATUIN_SHLVL" != "$SHLVL"
    set -gx ATUIN_SESSION (atuin uuid)
    set -gx ATUIN_SHLVL $SHLVL
end
set --erase ATUIN_HISTORY_ID

function _atuin_preexec --on-event fish_preexec
    set -g ATUIN_HISTORY_ID (atuin history start -- "$argv[1]")
end

function _atuin_postexec --on-event fish_postexec
    set -l s $status

    if test -n "$ATUIN_HISTORY_ID"
        ATUIN_LOG=error atuin history end --exit $s -- $ATUIN_HISTORY_ID &>/dev/null &
        disown
    end

    set --erase ATUIN_HISTORY_ID
end

# TODO: This can be inlined too.
function _atuin_tmux_popup_check
    if not test -n "$TMUX"
        echo 0
        return
    end
end

# TODO: There is likely a simpler way to do this too.
function _atuin_search
    set -l use_tmux_popup (_atuin_tmux_popup_check)

    set -l ATUIN_H
    if test "$use_tmux_popup" -eq 1
        set -l tmpdir (mktemp -d)
        if not test -d "$tmpdir"
            # if mktemp got errors
            set ATUIN_H "$(ATUIN_LOG=error ATUIN_QUERY=(commandline -b) atuin search $argv -i 3>&1 1>&2 2>&3)"
        else
            set -l result_file "$tmpdir/result"

            set -l query (commandline -b | string replace -a "'" "'\\''")
            set -l escaped_args ""
            for arg in $argv
                set escaped_args "$escaped_args '"(string replace -a "'" "'\\''" -- $arg)"'"
            end

            # In the popup, atuin goes to terminal, stderr goes to file
            set -l cdir (pwd)
            set -l popup_width "80%"
            set -l popup_height "60%"

            tmux display-popup -d "$cdir" -w "$popup_width" -h "$popup_height" -E -E -- \
                sh -c "ATUIN_SESSION='$ATUIN_SESSION' ATUIN_LOG=error ATUIN_QUERY='$query' atuin search $escaped_args -i 2>'$result_file'"

            if test -f "$result_file"
                set ATUIN_H (cat "$result_file" | string collect)
            end

            command rm -rf "$tmpdir"
        end
    else
        set ATUIN_H "$(ATUIN_LOG=error ATUIN_QUERY=(commandline -b) atuin search $argv -i 3>&1 1>&2 2>&3)"
    end

    set ATUIN_H (string trim -- $ATUIN_H) # trim whitespace

    if test -n "$ATUIN_H"
        commandline -r "$ATUIN_H"
    end
    commandline -f repaint
end

bind ctrl-r _atuin_search
