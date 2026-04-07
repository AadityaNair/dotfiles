# Drop this script into the conf.d directory in macOS systems.

abbr -a caps "screencapture -c" # Capture entire screen
abbr -a capa "screencapture -i -c" # Capture a specified area
abbr -a capw "screencapture -i -w -c" # Capture a window

abbr -a cc pbcopy
abbr -a pp pbpaste

set -x HOMEBREW_PREFIX /opt/homebrew
set -x HOMEBREW_CELLAR /opt/homebrew/Cellar
set -x HOMEBREW_REPOSITORY /opt/homebrew
set -x MANPATH /opt/homebrew/share/man $MANPATH
set -x INFOPATH /opt/homebrew/share/info $INFOPATH

set -x RUSTUP_HOME ~/.config/rustup
set -x CARGO_HOME ~/.local/share/cargo
set -a PATH ~/.config/rustup/toolchains/stable-aarch64-apple-darwin/bin/


# Bunch of applications which create folders in homedir. Currently only for personal laptop
set -x GEMINI_CONFIG_DIR "/Users/aaditya/.config/gemini"
set -x CLAUDE_CONFIG_DIR "/Users/aaditya/.config/claude"
set -x COPILOT_HOME "/Users/aaditya/.config/copilot"
