# Starships install instructions mention doing the following in your config:
# starship init fish | source
# The below script is parsed out of the above for performance reasons.
# If something starts to break, we will need to redo the above command.

set -x STARSHIP_CONFIG "$DOTFILES/shell_applications/starship.toml"

function fish_prompt
    set STARSHIP_CMD_PIPESTATUS $pipestatus
    set STARSHIP_CMD_STATUS $status
    # Account for changes in variable name between v2.7 and v3.0
    set STARSHIP_DURATION "$CMD_DURATION$cmd_duration"
    set STARSHIP_JOBS (count (jobs -p))
    #TODO: Consider not passing things we don't care about.
    starship prompt --terminal-width="$COLUMNS" --status=$STARSHIP_CMD_STATUS --pipestatus="$STARSHIP_CMD_PIPESTATUS" --cmd-duration=$STARSHIP_DURATION --jobs=$STARSHIP_JOBS
end

# Disable virtualenv prompt, it breaks starship
set -g VIRTUAL_ENV_DISABLE_PROMPT 1

# Remove default mode prompt
builtin functions -e fish_mode_prompt

set -gx STARSHIP_SHELL "fish"

# Set up the session key that will be used to store logs
# We don't use `random [min] [max]` because it is unavailable in older versions of fish shell
# TODO: Consider if we still need this
set -gx STARSHIP_SESSION_KEY (string sub -s1 -l16 (random)(random)(random)(random)(random)0000000000000000)
