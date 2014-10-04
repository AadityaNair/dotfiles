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
#alias t='todo'
alias sl='ls'
alias tst='ping www.google.com'
alias la='ll -a'
alias jcc='javac'

alias bashrc='vim ~/.bashrc'
alias vimrc='vim ~/.vimrc'

alias noproxy='export {http,https,ftp,socks}_proxy=""'
alias setproxy='export {http,https,ftp,socks}_proxy="http://proxy.iiit.ac.in:8080"'

alias err='echo $?'
mk () {
    mkdir -p "$*"
    cd "$*"
}
