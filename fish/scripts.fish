# The shell aliases/abbrs that are common across OS

alias cat="bat"
alias ip="ip -color"
alias kb="kubectl"
alias py="ipython3 --no-banner --autoindent --pprint"
alias tst="ping www.google.com"
alias ytdl='youtube-dl -o"%(title)s.%(ext)s"'

abbr -a vim nvim


# Manage dotfiles
alias dots="cd $DOTFILES"
alias crc="nvim $INSTALL/company_specific_commands.fish"
alias frc="nvim $FISH_SCRIPTS/config.fish"
alias src="nvim $FISH_SCRIPTS/scripts.fish"
alias trc="nvim $DOTFILES/tmux/config.tmux"
alias vrc="nvim $DOTFILES/vim/init.lua"


# CD Aliases
abbr --add dotdot --regex '^\.\.+$' --function multicd


# LS Aliases
# abbr -a ls "eza --group-directories-first --icons --classify --color=always"
function ls --wraps ls
    eza --group-directories-first --icons --classify --color=always $argv
end
abbr -a sl ls

function tree --wraps ls
    eza --group-directories-first --icons --classify --color=always --tree $argv
end

if test "$(uname)" = Darwin
    abbr -a caps "screencapture -c" # Capture entire screen
    abbr -a capa "screencapture -i -c" # Capture a specified area
    abbr -a capw "screencapture -i -w -c" # Capture a window

    abbr -a cc pbcopy
    abbr -a pp pbpaste


    set -x HOMEBREW_PREFIX /opt/homebrew
    set -x HOMEBREW_CELLAR /opt/homebrew/Cellar
    set -x HOMEBREW_REPOSITORY /opt/homebrew
    set -x PATH /opt/homebrew/bin /opt/homebrew/sbin $PATH
    set -x MANPATH /opt/homebrew/share/man $MANPATH
    set -x INFOPATH /opt/homebrew/share/info $INFOPATH
end

# TODO: We can just move this file into ~/.config/fish/conf.d
if test -f "$INSTALL/company_specific_commands.fish"
    source "$INSTALL/company_specific_commands.fish"
end

# Lazyload Kubectl nvm and pnpm settings whenever you can.
