
######## Initial Setup ########


znap install "zsh-users/zsh-completions"

# TODO: We should just figure out how completion works in zsh and not rely on plugins.
# znap source marlonrichert/zsh-autocomplete

# Don't check permissions for completions. Makes shell startup faster.
zstyle '*:compinit' arguments -u -C -w

bindkey '\t' menu-select "$terminfo[kcbt]" menu-select
bindkey -M menuselect '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete

####### General Configuration ########
# Insert the longest matching prefix before starting completions
zstyle ':autocomplete:*' insert-unambiguous yes

####### Application Level Configuration ##########

# Setup zoxide for recent directories completion while using `cd` 
# I always use `z` directly for completion so don't particularly need this feature.
# +autocomplete:recent-directories() {
#     typeset -ga reply=( ${(f)"$( zoxide query --list "$1" 2> /dev/null )"} )
# }

# zstyle ':completion:*:*' matcher-list 'm:{[:lower:]-}={[:upper:]_}' '+r:|[.]=**'
