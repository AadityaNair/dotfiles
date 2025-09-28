# Starships install instructions mention doing the following in your config:
# starship init fish | source
# The below script is parsed out of the above for performance reasons.
# If something starts to break, we will need to redo the above command.

set -x STARSHIP_CONFIG "$DOTFILES/shell_applications/starship.toml"

# TODO: For the usage we have, we don't need starship
function fish_prompt
    set STARSHIP_CMD_PIPESTATUS $pipestatus
    set STARSHIP_CMD_STATUS $status
    set STARSHIP_DURATION "$CMD_DURATION"
    set STARSHIP_JOBS (count (jobs -p))

    # TODO: Consider not passing things we don't care about.
    starship prompt --terminal-width="$COLUMNS"\
                    --status=$STARSHIP_CMD_STATUS\
                    --pipestatus="$STARSHIP_CMD_PIPESTATUS"\
                    --cmd-duration=$STARSHIP_DURATION\
                    --jobs=$STARSHIP_JOBS
end

