############# PREFIX KEY
unbind C-b
set-option -g prefix C-a  
bind C-a send-prefix


############# Clients and Session 
bind -n M-s new-session

bind -n M-r command-prompt -p "(rename-session) " "rename-session '%%'"
bind -n M-Up switch-client -p
bind -n M-Down switch-client -n

bind r source-file ~/.tmux.conf


############ Windows
bind -n M-a new-window -c "#{pane_current_path}"  

bind -n M-w command-prompt -p "(rename-window) " "rename-window '%%'"
bind -n M-Right next-window
bind -n M-Left previous-window

bind -n S-F7 swap-window -d -t :-1
bind -n S-F9 swap-window -d -t :+1


########## Panes
bind -n M-\\ split-window -h -c "#{pane_current_path}"
bind -n M-- split-window -v -c "#{pane_current_path}"

bind -n S-Left select-pane -L
bind -n S-Right select-pane -R
bind -n S-Up select-pane -U
bind -n S-Down select-pane -D

bind -n M-] set synchronize-panes
bind -n M-. resize-pane -Z

bind -n M-l next-layout  # Rotate through preset pane layouts.

# pipe-pane
# resize-pane
# capture-pane

########## Copy Mode
bind -n M-p copy-mode
bind -n F11 copy-mode    

# begin-selection
# clear-selection
# pipe-*
# rectangle-toggle
# search-*-incremental
# select-(line|word)
# previous-prompt
# copy-*

########## Mouse


##### Status line comm
# display-message
# display-popup

##### Others
# customize-mode
# display-panes

# TODO: `pane_current_path` doesn't work with symlink properly. 
# TODO: if-else in copy-mode
# TODO: Toggle mouse mode
# TODO: Capture pane doesn't send to copy buffer

# vim: ft=tmux
