# History substring search with the atuin backend.
# This is basically a port of the logic in https://gist.github.com/tyalie/7e13cfe2ec62d99fa341a07ed12ef7c0
#
# What the code basically does is,
#   1. Takes the search term and passes it to atuin in `get_command`
#   2. Maintains a global `index` which says how back in history we went.
#   3. Use `atuin_history_up` and `atuin_history_down` to increase/decrease the `index`
#   4. Resets the index when we enter the command or cancel the command via `reset_index`
# WARNING: Very very prone to off-by-one errors. Please be careful updating the index.
# TODO: Underline the query text

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
    set -l response $(atuin search \
        --filter-mode "$FILTER" \
        --search-mode "$MODE" \
        --limit 1 --format "{command}" \
        --offset $__hist_search_index -- "$__hist_search_orig_query")

    if test $status -eq 0
        commandline $response
        set __hist_search_curr_response $response
    else
        # If search fails, keep the last returned command
        commandline $__hist_search_curr_response
    end
end

function atuin_history_up
    if commandline --search-mode; or commandline --paging-mode
        up-or-search
        return
    end

    # If we are starting a new search or if we changed the query partway through a 
    # previous search, we start again from the beginning.
    if test $__hist_search_index -eq -1; or test $__hist_search_curr_response != $(commandline)
        set __hist_search_orig_query $(commandline)
        set __hist_search_curr_response $__hist_search_orig_query
        set __hist_search_index -1
    end
    set __hist_search_index (math $__hist_search_index + 1)

    get_command_and_update_prompt
end

function atuin_history_down
    if commandline --search-mode; or commandline --paging-mode
        down-or-search
        return
    end

    if test $__hist_search_curr_response != $(commandline)
        set __hist_search_index -1
        set __hist_search_orig_query $(commandline)
        return
    end

    set __hist_search_index (math $__hist_search_index - 1)
    if test $__hist_search_index -le -1
        commandline $__hist_search_orig_query
        set __hist_search_index -1
        return
    end

    get_command_and_update_prompt
end

bind up atuin_history_up
bind down atuin_history_down
