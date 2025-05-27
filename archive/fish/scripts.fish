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
# TODO: Investigate trying to reload config automatically
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
abbr -a ls "eza --group-directories-first"
abbr -a sl "eza --group-directories-first"

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

    # TODO: Copy pnpm configuration
end

if test -f "$INSTALL/company_specific_commands.fish"
    # TODO: Build company_specific_commands 
    source "$INSTALL/company_specific_commands.fish"
end

# TODO: copy functions from the shell_commons.sh file
# Function mk
# Function myip
# Function spectrum
# Function extract
# Lazyload Kubectl and nvm
