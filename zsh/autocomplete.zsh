# Module explanations are in https://zsh.sourceforge.io/Doc/Release/Zsh-Modules.html#The-zsh_002fcomplist-Module
# Options explanations in https://zsh.sourceforge.io/Doc/Release/Options.html

######## Initial Setup ########

zmodload zsh/complist  # Allow coloured completions

# Dont do permission checks while loading completions.
# Could be a security risk but makes things much faster.
zstyle '*:compinit' arguments -u -C -w

# (validate) Use caching so that we can autocomplete bigger commands.
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path $XDG_CACHE_HOME


znap install "zsh-users/zsh-completions"

# TODO: We should just figure out how completion works in zsh and not rely on plugins.
# znap source marlonrichert/zsh-autocomplete

bindkey '\t' menu-select "$terminfo[kcbt]" menu-select
bindkey -M menuselect '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete




####### General Configuration ########

## How completions work
unsetopt menu_complete # Do not pick the first completion in case of multiple options
zstyle ':autocomplete:*' insert-unambiguous yes  # But insert the longest matching sequence

setopt complete_in_word # (validate)
setopt always_to_end # (validate)
setopt complete_aliases # (validate)

zstyle ':completion:*:*:*:*:*' menu select # Allow moving across selections using arrow keys


## Application level configuration
zstyle ':completion:*' special-dirs true  # Complete . and .. special directories.
zstyle ':completion:*:*:*:*:processes' command "ps -o pid,user,comm -w -w" # special output for processes
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories # (validate) 

zstyle ':completion:*:ssh:*' hosts on  # Need to disable this in a place with large number of hosts

## Autocomplete Colours
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

## VALIDATE BELOW Fully
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes

zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Increase the number of errors based on the length of the typed word.
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'

# Don't complete unavailable commands.
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'

# Array completion element sorting.
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# Directories
# zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
zstyle ':completion:*' squeeze-slashes true

# zstyle ':completion:*:*' matcher-list 'm:{[:lower:]-}={[:upper:]_}' '+r:|[.]=**'
