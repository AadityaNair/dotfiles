export ZSH=/home/Aaditya/.oh-my-zsh

ZSH_THEME="random"
COMPLETION_WAITING_DOTS="true"
ZSH_CUSTOM=/home/Aaditya/projects/dotfiles

eval `dircolors /home/Aaditya/Public/dircolors-solarized/dircolors.ansi-dark`
HIST_STAMPS="dd/mm/yyyy"
plugins=(git common-aliases compleat dircycle dirhistory gitfast git-extras sudo yum)

export PATH="/usr/lib64/qt-3.3/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:/home/Aaditya/.local/bin:/home/Aaditya/bin"

source $ZSH/oh-my-zsh.sh
source /home/Aaditya/projects/dotfiles/shell_commons
