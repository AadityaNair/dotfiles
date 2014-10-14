# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

export {http,https,ftp,socks}_proxy="http://proxy.iiit.ac.in:8080"
numlockx on
alias sl='ls'
alias tst='ping www.google.com'
alias la='ll -a'

alias jcc='javac'
alias python="ipython --autoindent --classic --automagic --banner --pprint"
alias storm="bash ~/Downloads/WebStorm-135.1063/bin/webstorm.sh &"
alias bashrc='vim ~/.bashrc;source ~/.bashrc'
alias vimrc='vim ~/.vimrc'

alias noproxy='export {http,https,ftp,socks}_proxy=""'
alias setproxy='export {http,https,ftp,socks}_proxy="http://proxy.iiit.ac.in:8080"'

alias proj="cd ~/Projects/ssad26/source/BeaconServer/"
alias err='echo $?'
mk () {
    mkdir -p "$*"
    cd "$*"
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
