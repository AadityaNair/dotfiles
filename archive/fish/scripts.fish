# The shell aliases/abbrs that are common across OS

# TODO: Consider using functions for some of these.
#       For a bunch of these, you don't want the abbreviation expanded.

abbr -a cat "bat"
abbr -a ip "ip -color"
abbr -a kb "kubectl"
abbr -a py "ipython3 --no-banner --autoindent --pprint"
abbr -a tst "ping www.google.com"
abbr -a vim "nvim"
abbr -a ytdl 'youtube-dl -o"%(title)s.%(ext)s"'


# Manage dotfiles
abbr -a dots "cd $INSTALL/dotfiles"
abbr -a crc "nvim $INSTALL/company_specific_commands.fish"
abbr -a frc "nvim $INSTALL/dotfiles/archive/fish/config.fish"
abbr -a src "nvim $INSTALL/dotfiles/archive/fish/scripts.fish"
abbr -a trc "nvim $INSTALL/dotfiles/tmux/config.tmux"
abbr -a vrc "nvim $INSTALL/dotfiles/vim/init.lua"


# CD Aliases
# This replicates .. = cd ../ and ... = cd ../.. for any number of dots.
function multicd
    echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
end
abbr --add dotdot --regex '^\.\.+$' --function multicd


# LS Aliases
abbr -a ls "eza --group-directories-first --icons --classify --color=always"
abbr -a sl "eza --group-directories-first --icons --classify --color=always"

function tree --wraps ls
    eza --group-directories-first --icons --classify --color=always --tree $argv
end

if test "$(uname)" = "Darwin"
    abbr -a caps "screencapture -c" # Capture entire screen
    abbr -a capa "screencapture -i -c" # Capture a specified area
    abbr -a capw "screencapture -i -w -c" # Capture a window

    abbr -a cc "pbcopy"
    abbr -a pp "pbpaste"


    set -x HOMEBREW_PREFIX "/opt/homebrew"
    set -x HOMEBREW_CELLAR "/opt/homebrew/Cellar"
    set -x HOMEBREW_REPOSITORY "/opt/homebrew"
    set -x PATH "/opt/homebrew/bin" "/opt/homebrew/sbin" $PATH
    set -x MANPATH "/opt/homebrew/share/man" $MANPATH
    set -x INFOPATH "/opt/homebrew/share/info" $INFOPATH
end

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

    if test -f $argv[1]
        echo "The argument must be a file"
        return 1
    end

    switch $argv[1]
        case *.tar.bz2 *.tbz2
            tar xjf "$argv[1]"
        case *.tar.gz *.tgz
            tar xzf "$argv[1]"
        case *.bz2
            bunzip2 $argv[1]
        case *.rar
            unrar x $argv[1]
        case *.gz
            gunzip $argv[1]
        case *.tar
            tar xf $argv[1]
        case *.zip
            unzip $argv[1]
        case *.Z
            uncompress $argv[1]
        case *.7z
            7zr e $argv[1]
        case *.rpm
            rpm2cpio $argv[1] | cpio -idmv
        case *
            echo "Can't `extract` this file. Please check."
    end
end

if test -f "$INSTALL/company_specific_commands.fish"
    source "$INSTALL/company_specific_commands.fish"
end

# TODO: Lazyload Kubectl nvm and pnpm settings
