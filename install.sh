#!/usr/bin/zsh

set -exo pipefail

# TODO: Go back to old pwd
# TODO: AutoInstall Plugins
cd $HOME

#Exit if repo already exists.
if [ -d .dotfiles ]; then
    echo "The repo seems already setup. Exiting"
    exit 1
fi

#Download the repository
git clone --depth 1 https://github.com/AadityaNair/dotfiles.git .dotfiles

# 1. Install ZSH setup
# --------------------

setup_zsh()
{
    cd $HOME
    if [ -f .zshrc ]; then
        echo ".zshrc exists. Taking backup"
        mv .zshrc zshrc.bkp
    fi

    ln -s .dotfiles/zsh/zshrc .zshrc

    git clone https://github.com/AadityaNair/zplug.git .zplug
    cd .zplug
    git apply ~/.dotfiles/zsh/secret_sauce.diff

    chsh -s /bin/zsh
}

# 2. Install NeoVIM setup
# -----------------------

setup_vim()
{
    mkdir -p .config/nvim/
    cd .config/nvim

    if [ -f init.vim ]; then
        echo "init.vim exists. Taking backup"
        mv init.vim init.vim.bkp
    fi

    ln -s ~/.dotfiles/vim/init.vim .

    curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    #Install all plugins
    nvim +PlugInstall +UpdateRemotePlugins +qa
}

# 3. Install TMUX setup
# ---------------------

setup_tmux()
{
    cd $HOME
    if [ -f .tmux.conf ]; then
        echo ".tmux.conf exists. Taking backup"
        mv .tmux.conf tmux.conf.bkp
    fi
    ln -s .dotfiles/tmux/tmux.conf .tmux.conf

    mkdir -p .tmux/plugins/
    cd .tmux/plugins

    git clone --depth 1 https://github.com/tmux-plugins/tpm.git
}

setup_zsh 
setup_vim
setup_tmux
