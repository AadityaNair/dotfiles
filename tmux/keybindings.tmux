unbind C-b
set-option -g prefix C-a
bind C-a send-prefix
########## Clients and Session 
# refresh-client
bind -n M-s new-session
bind -n M-r command-prompt -p "(rename-session) " "rename-session '%%'"
bind -n M-Up switch-client -p
bind -n M-Down switch-client -n

########## Windows
# begin-selection
# clear-selection
# pipe-*
# rectangle-toggle
# search-*-incremental
# select-(line|word)


bind -n M-a new-window -c "#{pane_current_path}"  # TODO: `pane_current_path` doesn't work with symlink properly
bind -n M-Right next-window
bind -n M-Left previous-window

bind -n S-F7 swap-window -d -t :-1
bind -n S-F9 swap-window -d -t :+1
bind -n M-w command-prompt -p "(rename-window) " "rename-window '%%'"

########## Panes
# pane-layout: even-(horizontal|vertical)

# display-panes
# pipe-pane
# resize-pane

bind -n M-\\ split-window -h -c "#{pane_current_path}"
bind -n M-- split-window -v -c "#{pane_current_path}"
bind -n S-Left select-pane -L
bind -n S-Right select-pane -R
bind -n S-Up select-pane -U
bind -n S-Down select-pane -D
bind -n M-] setw synchronize-panes
bind -n M-. resize-pane -Z

bind r source-file ~/.tmux.conf

##### Status line comm
# display-message
# display-popup

##### Copy Mode
bind -n M-n copy-mode
bind -n M-p copy-mode
bind -n S-F1 copy-mode
bind -n F11   copy-mode    # Just in case pg_up/down doesn't exist. Like in a macbook.
# previous-prompt
# copy-*

# TODO: copy-pane, auto-layout for panes, right-click for mouse
# TODO: Display panes

# vim: ft=tmux
