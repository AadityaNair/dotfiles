# vim: ft=zsh
# export MANPAGER="bat -l man"
export EDITOR="nvim"
export IPYTHONDIR="~/.config/ipython"
export VIRTUALENVWRAPPER_PYTHON=$(which python3)
################ ALIASES #############################

# Random useful aliases
alias cat='bat'
alias ip='ip -color'
alias kb='kubectl'
alias py='ipython3 --no-banner --autoindent --pprint'
alias tmux='tmux attach || tmux new'
alias tst='ping www.google.com'
alias vim='nvim'
alias youtube-dl='youtube-dl -o"%(title)s.%(ext)s"'

# Get all config files in one shot
alias dots="cd $INSTALL/dotfiles/"

# TODO: Ivestigate why adding "source ~/.zshrc" breaks fast syntax highlighting.
alias crc="vim ~/.config/company_specific_commands.sh"
alias frc="vim $INSTALL/dotfiles/zsh/config.fish"
alias src="vim $INSTALL/dotfiles/zsh/shell_commons.sh"
alias trc="vim $INSTALL/dotfiles/tmux/config.tmux"
alias vrc="vim $INSTALL/dotfiles/vim/init.lua"
alias zrc="vim $INSTALL/dotfiles/zsh/zshrc"


# CD aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias -- -='cd -'

# LS aliases
alias ls='eza --group-directories-first'
#alias lsa='ls -lah'
#alias l='ls -lah'
alias ll='ls -lh'
alias la='ls -lAh'
alias sl='ls'

################ FUNCTIONS #####################

function mk () {
    mkdir -p "$*"
    cd "$*"
}

function spectrum() {
    for i in {0..255}; do
        printf "\x1b[38;5;${i}mcolour${i}\x1b[0m\n"
    done
}

function myip(){
    curl http://ipecho.net/plain
    printf '\n'
}

function extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)        tar xjf $1        ;;
            *.tar.gz)         tar xzf $1        ;;
            *.bz2)            bunzip2 $1        ;;
            *.rar)            unrar x $1        ;;
            *.gz)             gunzip $1         ;;
            *.tar)            tar xf $1         ;;
            *.tbz2)           tar xjf $1        ;;
            *.tgz)            tar xzf $1        ;;
            *.zip)            unzip $1          ;;
            *.Z)              uncompress $1     ;;
            *.7z)             7zr e $1          ;;
            *)                echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Lazy load kubectl completions
function kubectl() {
    if ! type __start_kubectl >/dev/null 2>&1; then
        source <(command kubectl completion zsh)
        compdef kb=kubectl
    fi

    command kubectl "$@"
}

# Added nvm function because nvm loading takes a ton of time.
# With this, nvm will load once I type nvm once and will override this function
# So for every terminal type nvm twice
function nvm(){
    unset -f nvm

    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    nvm "$@"
}

