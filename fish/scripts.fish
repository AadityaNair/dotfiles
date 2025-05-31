# The shell aliases/abbrs that are common across OS

# Aliases are written as functions for performance reasons
function cat --wraps cat
    bat $argv
end
function ip --wraps ip
    ip -color $argv
end
function kb --wraps kubectl
    kubectl $argv
end
function ytdl --wraps youtube-dl
    youtube-dl -o"%(title)s.%(ext)s" $argv
end
function tst
    ping www.google.com
end
function py
    ipython3 --no-banner --autoindent --pprint $argv
end

abbr -a vim nvim


# Manage dotfiles
function dots
    cd $DOTFILES
end
function frc
    nvim $FISH_SCRIPTS/config.fish
end
function src
    nvim $FISH_SCRIPTS/scripts.fish
end
function trc
    nvim $DOTFILES/tmux/config.tmux
end
function vrc
    nvim $DOTFILES/vim/init.lua
end


# CD Aliases
# This replicates .. = cd ../ and ... = cd ../.. for any number of dots.
function multicd
    echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
end
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

# Navigation functions
function sudo_prev
    set -l cur_buf (commandline)

    if test -n $cur_buf
        if not string match -q "sudo *" $cur_buf  # Only add sudo if it isnt already there.
            commandline "sudo $cur_buf"
        end
    else
        commandline "sudo $history[1]"
    end
end
bind escape,escape sudo_prev

function last_history_item
    echo $history[1]
end
abbr -a !! --position anywhere --function last_history_item

# TODO: Unable to bind alt-. for some reason. Pls fix.
bind alt-/ forward-word
bind alt-comma backward-word
bind alt-i history-token-search-backward
# We already do alt/ctrl+backspace to kill word

function mk
    mkdir -p "$argv[1]"
    cd "$argv[1]"
end


function myip
    curl https://ipecho.net/plain
    printf "\n"
end

function extract
    if test (count $argv) -ne 1
        echo "You must only provide one file"
        return 1
    end

    if not test -f $argv[1]
        echo "The argument must be a file"
        return 1
    end

    switch $argv[1]
        case "*.tar.bz2" "*.tbz2"
            tar xjf "$argv[1]"
        case "*.tar.gz" "*.tgz"
            tar xzf "$argv[1]"
        case "*.tar.xz"
            tar xf "$argv[1]"
        case "*.bz2"
            bunzip2 $argv[1]
        case "*.rar"
            unrar x $argv[1]
        case "*.gz"
            gunzip $argv[1]
        case "*.tar"
            tar xf $argv[1]
        case "*.zip"
            unzip $argv[1]
        case "*.Z"
            uncompress $argv[1]
        case "*.7z"
            7zr e $argv[1]
        case "*.rpm"
            rpm2cpio $argv[1] | cpio -idmv
        case "*"
            echo "Can't `extract` this file. Please check."
    end
end

# Far future todo: Lazyload Kubectl nvm and pnpm settings whenever you can.
