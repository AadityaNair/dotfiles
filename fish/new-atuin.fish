
# We can't replace `atuin uuid` for multiple reasons:
# 1. It works across platforms.
# 2. We need UUIDv7 for atuin operations — it has ordering properties atuin relies on.
# 3. The best platform-specific alternative only saves ~2ms.
# 4. We can't use a static string because this is the primary key for the db.
#    A static value would cause all new history entries to overwrite the same row.
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

set -g ATUIN_POPUP_WIDTH "80%"
set -g ATUIN_POPUP_HEIGHT "60%"

function _atuin_search
    set -l ATUIN_H
    set -l tmpdir (mktemp -d)
    if test -n "$TMUX"; and test -d "$tmpdir"
        set -l result_file "$tmpdir/result"
        set -l query (commandline -b | string replace -a "'" "'\\''")
        set -l escaped_args ""
        for arg in $argv
            set escaped_args "$escaped_args '"(string replace -a "'" "'\\''" -- $arg)"'"
        end

        # In the popup, atuin's TUI goes to the terminal (stdout), and the
        # selected result is written to stderr, which we redirect to a file.
        tmux display-popup -d (pwd) -w "$ATUIN_POPUP_WIDTH" -h "$ATUIN_POPUP_HEIGHT" -E -E -- \
            sh -c "ATUIN_SESSION='$ATUIN_SESSION' ATUIN_LOG=error ATUIN_QUERY='$query' atuin search $escaped_args -i 2>'$result_file'"

        if test -f "$result_file"
            set ATUIN_H "$(cat "$result_file")"
        end
    else
        # Without tmux: swap stdout/stderr so the TUI renders to the terminal
        # and the selected result is captured via command substitution.
        set ATUIN_H "$(ATUIN_LOG=error ATUIN_QUERY=(commandline -b) atuin search $argv -i 3>&1 1>&2 2>&3)"
    end

    command rm -rf "$tmpdir"

    if test -n "$ATUIN_H"
        commandline -r "$ATUIN_H"
    end
    commandline -f repaint
end

bind ctrl-r _atuin_search
