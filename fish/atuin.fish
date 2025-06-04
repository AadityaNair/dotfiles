# Atuin's init script parsed out of atuin init fish

# We can't replace this for multiple reasons:
# 1. `atuin uuid` works across platforms.
# 2. We need uuid v7 for atuin operations and AFAIK, no other platform specific application supports it
#    UUIDv7 has some ordering advantages that atuin internally uses.
# 3. The best platform specific application reduces the calltime by only 2ms
# 4. We can't replace this with a static string because this is also used as the primary key for the db.
#    If we replace it, all new history elements will just override the same row.
set -gx ATUIN_SESSION (atuin uuid)
set --erase ATUIN_HISTORY_ID

function _atuin_preexec --on-event fish_preexec
    set -g ATUIN_HISTORY_ID (atuin history start -- "$argv[1]")
end

function _atuin_postexec --on-event fish_postexec
    set -l s $status # This is done so that we have the command status before next commands override it.

    if test -n "$ATUIN_HISTORY_ID"
        # todo: Maybe we can speed this up by supplying $CMD_DURATION to the script directly?
        ATUIN_LOG=error atuin history end --exit $s -- $ATUIN_HISTORY_ID &>/dev/null &
        disown
    end

    set --erase ATUIN_HISTORY_ID
end

function _atuin_search
    set -l keymap_mode emacs
    
    set -l ATUIN_H "$(ATUIN_SHELL_FISH=t ATUIN_LOG=error ATUIN_QUERY=(commandline -b) atuin search --keymap-mode=$keymap_mode $argv -i 3>&1 1>&2 2>&3)"

    if test -n "$ATUIN_H"
        if string match --quiet '__atuin_accept__:*' "$ATUIN_H"
          set -l ATUIN_HIST "$(string replace "__atuin_accept__:" "" -- "$ATUIN_H")"
          commandline -r "$ATUIN_HIST"
          commandline -f repaint
          return
        else
          commandline -r "$ATUIN_H"
        end
    end

    commandline -f repaint
end

bind ctrl-r _atuin_search
bind -M insert ctrl-r _atuin_search
