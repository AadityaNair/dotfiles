# WARNING: Atuin by default expects `atuin uuid` for ATUIN_SESSION. This only makes sense while searching with a
#          `session` filter. We don't use that. On top of that, `atuin uuid` is the costliest part of the startup.
#          So, we have optimised to leave it as a static string. This definitely breaks atuin session search, making it same as global

set -gx ATUIN_SESSION "non-standard-default"

set --erase ATUIN_HISTORY_ID
function _atuin_preexec --on-event fish_preexec
    set -g ATUIN_HISTORY_ID (atuin history start --hook -- "$argv[1]" 2>/dev/null)
end

function _atuin_postexec --on-event fish_postexec
    set -l s $status

    if test -n "$ATUIN_HISTORY_ID"
        atuin history end --hook --exit $s -- $ATUIN_HISTORY_ID &>/dev/null &
        disown
    end

    set --erase ATUIN_HISTORY_ID
end
