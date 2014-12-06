# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
export HISTCONTROL=ignoredups:erasedups  
shopt -s histappend
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

# VARIABLES
SUBLIME_LOCATION="/home/Prometheus/Public/IDE/sublime_text_3/"
TABLE_LOCATION="/home/Prometheus/Public/IDE/LightTable/"
# ALIASES

#export {http,https,ftp,socks}_proxy="http://proxy.iiit.ac.in:8080"
numlockx on
alias sl='ls'
alias tst='ping www.google.com'
alias la='ll -a'

alias jcc='javac'
alias python="ipython --autoindent --automagic --banner --pprint"
alias storm="bash ~/Downloads/WebStorm-135.1063/bin/webstorm.sh &"
alias brc='vim ~/projects/dotfiles/.bashrc;source ~/.bashrc'
alias vrc='vim ~/projects/dotfiles/.vimrc'

alias noproxy='export {http,https,ftp,socks}_proxy=""'
alias setproxy='export {http,https,ftp,socks}_proxy="http://proxy.iiit.ac.in:8080"'

alias proj="cd ~/projects/ssad26/source/BeaconServer/"
alias err='echo $?'

alias svi="sudo vim"
alias dc="sudo /home/Prometheus/Downloads/linuxdcpp-1.0.3/linuxdcpp"


# FUNCTIONS


mk () {
    mkdir -p "$*"
    cd "$*"
}

sublime () {
    $SUBLIME_LOCATION/sublime_text $@ &
}

table () {
    $TABLE_LOCATION/LightTable $@ &
}

start() {
    for serv in "$@"
    do
        sudo service $serv start > /dev/null 2>&1
        if [ $? -eq 0 ]
        then
            echo $serv: "$( tput setaf 2)Started $(tput sgr 0)"
        else
            echo $serv: "$( tput setaf 1)Unable to Start.$( tput sgr 0)"
        fi
    done 
}

stop() {
    for serv in "$@"
    do
        sudo service $serv stop > /dev/null 2>&1
        if [ $? -eq 0 ]
        then
            echo $serv: "$( tput setaf 2)Stoped.$( tput sgr 0)"
        else
            echo $serv: "$( tput setaf 1)Unable to Stop.$( tput sgr 0)"
        fi
    done 
}
