# Drop this script into the conf.d directory in macOS systems.

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
