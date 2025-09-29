############# PREFIX KEY
unbind C-b  # Unbind the current prefix key.
set-option -g prefix C-a  # Set prefix to Ctrl+a
bind C-a send-prefix  # Set prefix + Ctrl+a (ie Ctrl+a x2) to sent Ctrl-a to the terminal.


############# Clients and Session 
bind -n M-s new-session  # Use Alt+s to create a new session.

bind -n M-r command-prompt -p "(rename-session) " "rename-session '%%'"  # Allow renaming session names.
bind -n M-Up switch-client -p  # Move to the previous session.
bind -n M-Down switch-client -n  # Move to the next session.

bind r source-file ~/.tmux.conf  # Reload file online.


############ Windows
bind -n M-a new-window -c "#{pane_current_path}"  # Create a new window in the same path as the calling pane.

bind -n M-w command-prompt -p "(rename-window) " "rename-window '%%'"  # Allow renaming windows.
bind -n M-Right next-window  # Navigate to the next window.
bind -n M-Left previous-window  # Navigate to the previous window.

bind -n S-F7 swap-window -d -t :-1  # Move the current window to the left.
bind -n S-F9 swap-window -d -t :+1  # Move the current window to the right.


########## Panes
bind -n M-\\ split-window -h -c "#{pane_current_path}"  # Split the window/pane vertically.
bind -n M-- split-window -v -c "#{pane_current_path}"  # Split the window/pane horizontally.

bind -n S-Left select-pane -L  # Select pane on the left.
bind -n S-Right select-pane -R  # Select pane on the right.
bind -n S-Up select-pane -U  # Select pane above the current pane.
bind -n S-Down select-pane -D  # Select pane below the current pane.

bind -n M-] set synchronize-panes  # Input is copied to all the panes in the window. Press again to revert.
bind -n M-. resize-pane -Z  # The pane is zoomed to occupy the full terminal. Press again to revert.

bind -n M-l next-layout  # Rotate through preset pane layouts.


########## Copy Mode
bind -n M-p copy-mode  # Enable copy mode.
bind -n F11 copy-mode  # Alternate key to enable copy mode.

# The below keybindings only work in copy mode.
bind -T copy-mode-vi Space send-keys -X begin-selection  # Start selecting text to copy.
bind -T copy-mode-vi q send-keys -X cancel  #  Exit copy mode.
bind -T copy-mode-vi Escape send-keys -X clear-selection  # Clear the current selection.
bind -T copy-mode-vi Enter send-keys -X copy-selection-and-cancel  # Copy current selection and exit copy-mode.
bind -T copy-mode-vi v send-keys -X rectangle-toggle  # Toggle between copying lines or copying a rectangle
bind -T copy-mode-vi r send-keys -X refresh-from-pane  # Refresh contents of pane. Useful when more data has showed up.

# The below two keybindings are useful when you want to copy a command from the terminal.
# The keybindings will take you to right after you have entered the command.
# For this to work, your shell/prompt should emit OSC133 escape codes. fish shell does it by default.
bind -T copy-mode-vi p send-keys -X next-prompt -o  # Navigate to next terminal prompt.
bind -T copy-mode-vi P send-keys -X previous-prompt -o  # Navigate to previous terminal prompt.
# set-mark/jump-to-mark

bind -T copy-mode-vi / send-keys -X search-forward  # Search below where you currently are.
bind -T copy-mode-vi N send-keys -X search-reverse  # Search above where you currently are.
# search-(forward|backward)-incremental

## Possibly useful search stuff
# (next|previous)-matching-bracket
# (next|previous)-paragraph
# copy-pipe
# copy-selection
# copy-selection-no-clear
# history-(bottom|top) to copy entire pane
# next-space
# next-word(-end)
# pipe


########## Mouse
bind -n M-m set mouse  # Toggle enabling/disabling mouse.
# copy-line-and-cancel


##### Other cool stuff to maybe test later
# confirm-before
# customize-mode
# display-menu
# display-message
# display-panes
# display-popup

# TODO: `pane_current_path` doesn't work with symlink properly. 
# TODO: if-else for entering copy-mode
# TODO: Keybinding to copy entire window/pane.
# TODO: If set window name, disable window renaming
# TODO: Starship (or its integration with fish) is eating up OSC 133 codes and breaking prompt-search.
# vim: ft=tmux
