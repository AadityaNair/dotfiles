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

# Configure atuin search
set MODE fulltext # Possible options being: prefix, fulltext, fuzzy, skim
set FILTER global # Possible options being: global, host, session, directory, workspace

set index -1
set orig_query ""

function reset_index --on-event fish_prompt --on-event fish_cancel
    set index -1
end

function get_command
    set -l offset $argv[1]
    set -l query $argv[2]

    atuin search \
        --filter-mode "$FILTER" \
        --search-mode "$MODE" \
        --limit 1 --format "{command}" \
        --offset $offset -- "$query"
end

function atuin_history_up
    if test $index -eq -1
        set orig_query $(commandline)
    end

    set index (math $index + 1)
    set hist_item $(get_command $index $orig_query)
    commandline $hist_item
end

function atuin_history_down
    set index (math $index - 1)
    if test $index -le -1
        commandline $orig_query
        set index -1
        return
    end

    set hist_item $(get_command $index $orig_query)
    commandline $hist_item
end

bind up atuin_history_up
bind down atuin_history_down
