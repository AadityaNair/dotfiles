# History substring search with the atuin backend.
# This is basically a port of the logic in https://gist.github.com/tyalie/7e13cfe2ec62d99fa341a07ed12ef7c0
#
# What the code basically does is,
#   1. Takes the search term and passes it to atuin in `get_command`
#   2. Maintains a global `index` which says how back in history we went.
#   3. Use `atuin_history_up` and `atuin_history_down` to increase/decrease the `index`
#   4. Resets the index when we enter the command or cancel the command via `reset_index`
# NOTE: Very very prone to off-by-one errors. Please be careful updating the index.

# TODO: Make the index more reasonable to read. I don't like the current code much.
# TODO: Underline the query text
# TODO: Reset index when we edit the code

# Configure atuin search
set MODE fulltext # Possible options being: prefix, fulltext, fuzzy, skim
set FILTER global # Possible options being: global, host, session, directory, workspace

set index -1
set orig_query ""
set curr_response ""

function reset_index --on-event fish_prompt --on-event fish_cancel
    set index -1
end

function get_command_and_update_prompt
    set -l response $(atuin search \
        --filter-mode "$FILTER" \
        --search-mode "$MODE" \
        --limit 1 --format "{command}" \
        --offset $index -- "$orig_query")

    if test $status -eq 0
        commandline $response
        set curr_response $response
    else
        # If search fails, keep the last returned command
        commandline $curr_response
    end
end

function atuin_history_up
    if commandline --search-mode; or commandline --paging-mode
        up-or-search
        return
    end

    # If we are starting a new search or if we changed the query partway through a 
    # previous search, we start again from the beginning.
    if test $index -eq -1; or test $curr_response != $(commandline)
        set orig_query $(commandline)
        set curr_response $orig_query
        set index -1
    end
    set index (math $index + 1)

    get_command_and_update_prompt
end

function atuin_history_down
    if commandline --search-mode; or commandline --paging-mode
        down-or-search
        return
    end

    if test $curr_response != $(commandline)
        set index -1
        set orig_query $(commandline)
        return
    end

    set index (math $index - 1)
    if test $index -le -1
        commandline $orig_query
        set index -1
        return
    end

    get_command_and_update_prompt
end

bind up atuin_history_up
bind down atuin_history_down
