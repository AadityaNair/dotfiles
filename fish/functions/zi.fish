# Parsed out of zoxide init fish for performance reasons.

# Jump to a directory using interactive search.
function zi
    set -l result (command zoxide query --interactive -- $argv)
    and cd $result
end
