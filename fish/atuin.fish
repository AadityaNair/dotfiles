
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
