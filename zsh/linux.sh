export TERM=tmux-256color
alias htop='TERM=screen htop'

alias noproxy='unset {http,https,ftp,socks,no}_proxy'
alias open="xdg-open"
alias irssi='TERM=screen-256color irssi'
export MANPAGER='bat -l man -p'

eval `dircolors $INSTALL/dotfiles/zsh/dircolors.ansi-dark`

#TODO: Have two aliases to copy/paste from/to terminal
# Check out clipcopy and clippaste from OMZ
# Use cc and pp to match with macos
