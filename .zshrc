if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

eval `dircolors /home/Aaditya/Public/dircolors-solarized/dircolors.ansi-dark`
export PATH="/usr/lib64/qt-3.3/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:/home/Aaditya/.local/bin:/home/Aaditya/bin"

setopt AUTO_CD
setopt MULTIOS
setopt ZLE
setopt EXTENDED_GLOB
setopt CORRECT

source /home/Aaditya/projects/dotfiles/shell_commons
. /etc/profile.d/vte.sh

sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    [[ $BUFFER != sudo\ * ]] && LBUFFER="sudo $LBUFFER"
}
zle -N sudo-command-line
# Defined shortcut keys: [Esc] [Esc]
bindkey "\e\e" sudo-command-line
