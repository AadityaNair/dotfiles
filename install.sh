#!/usr/bin/zsh

cd $HOME

#Download the repository
git clone --depth 1 https://github.com/AadityaNair/dotfiles.git .dotfiles

# 1. Install ZSH setup
if [ -f ~/.zshrc ]; then
    echo ".zshrc exists. taking backup"
    mv ~/.zshrc ~/zshrc.bkp
fi

ln -s .dotfiles/zsh/zshrc $HOME/.zshrc
if [ $? -ne 0 ];then
    echo "Link Failed"
fi 

mkdir -p .antigen
curl -L git.io/antigen > .antigen/antigen.zsh
source .antigen/antigen.zsh
if [ $? -ne 0 ];then
    echo "source Failed"
fi
antigen apply
if [ $? -ne 0 ];then
    echo "apply Failed"
fi

#chsh -s /bin/zsh

# 2. Install VIM setup

# 3. Install TMUX setup
