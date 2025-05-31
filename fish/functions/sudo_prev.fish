function sudo_prev
    set -l cur_buf (commandline)

    if test -n $cur_buf
        if not string match -q "sudo *" $cur_buf  # Only add sudo if it isnt already there.
            commandline "sudo $cur_buf"
        end
    else
        commandline "sudo $history[1]"
    end
end
