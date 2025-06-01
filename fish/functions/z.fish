# Parsed out of zoxide init fish
# Jump to a directory using only keywords.
function z
    set -l argc (count $argv)
    # There are two cases that we have removed, because we don't use it
    # 1. pressing just z to go to $HOME
    # 2. pressing z - to go to the previous PWD.
    # 3. Some shennanigans with __zoxide_z_prefix_regex.
    # We will come back to any of the above, if they are truly needed.
    # Also removed is the competion stuff, because I haven't seen completion being used here.
   if test $argc -eq 1 -a -d $argv[1]
        cd $argv[1]
    else
        set -l result (command zoxide query --exclude (builtin pwd -L) -- $argv)
        and cd $result
    end
end
