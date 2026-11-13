# History substring search with the atuin backend.
# This is basically a port of the logic in https://gist.github.com/tyalie/7e13cfe2ec62d99fa341a07ed12ef7c0
#
# What the code basically does is,
#   1. Takes the search term and passes it to atuin in `get_command`
#   2. Maintains a global `index` which says how back in history we went.
#   3. Use `atuin_history_up` and `atuin_history_down` to increase/decrease the `index`
#   4. Resets the index when we enter the command or cancel the command via `reset_index`
# WARNING: Very very prone to off-by-one errors. Please be careful updating the index.
# NOTE: Fish has no API to highlight part of the commandline buffer without using selection mode (which breaks editing).
#       So we cannot hightlight the query string.

# Configure atuin search
set MODE fulltext # Possible options being: prefix, fulltext, fuzzy, skim
set FILTER global # Possible options being: global, host, session, directory, workspace

set __hist_search_index -1
set __hist_search_orig_query ""
set __hist_search_curr_response ""

function reset_index --on-event fish_prompt --on-event fish_cancel
    set __hist_search_index -1
end

function get_command_and_update_prompt
    # Quoted "$()" preserves newlines as a single string instead of splitting into a list.
    set -l response "$(atuin search \
        --filter-mode "$FILTER" \
        --search-mode "$MODE" \
        --limit 1 --format "{command}" \
        --offset $__hist_search_index -- "$__hist_search_orig_query")"

    if test $status -eq 0
        commandline -- "$response"
        set __hist_search_curr_response "$response"
        return 0
    else
        # If search fails, keep the last returned command
        commandline -- "$__hist_search_curr_response"
        return 1
    end
end

function atuin_history_up
    if commandline --search-mode; or commandline --paging-mode
        up-or-search
        return
    end

    # If we are starting a new search or if we changed the query partway through a
    # previous search, we start again from the beginning.
    if test $__hist_search_index -eq -1; or test "$__hist_search_curr_response" != "$(commandline)"
        set __hist_search_orig_query "$(commandline)"
        set __hist_search_curr_response "$__hist_search_orig_query"
        set __hist_search_index -1
    end
    set __hist_search_index (math $__hist_search_index + 1)

    # Clamp: if there is no older match, stay where we were instead of
    # inflating the index (which would take N dead downs to unwind).
    if not get_command_and_update_prompt
        set __hist_search_index (math $__hist_search_index - 1)
    end
end

function atuin_history_down
    if commandline --search-mode; or commandline --paging-mode
        down-or-search
        return
    end

    if test "$__hist_search_curr_response" != "$(commandline)"
        set __hist_search_index -1
        set __hist_search_orig_query "$(commandline)"
        set __hist_search_curr_response "$(commandline)"
        return
    end

    set __hist_search_index (math $__hist_search_index - 1)
    if test $__hist_search_index -le -1
        commandline -- "$__hist_search_orig_query"
        set __hist_search_index -1
        return
    end

    # Clamp: if the offset has no match (e.g. index was inflated before this
    # fix), undo the decrement so we don't drift.
    if not get_command_and_update_prompt
        set __hist_search_index (math $__hist_search_index + 1)
    end
end

bind up atuin_history_up
bind down atuin_history_down

# Interactive atuin TUI search (Ctrl-R), with tmux popup support.
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
