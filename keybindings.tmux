unbind-key -n C-a
set -g prefix ^A
set -g prefix2 ^A
bind a send-prefix

# ------------------------------------------- User-defined 

bind-key -n S-F1 new-window -k -n help "sh -c 'less help.tmux.txt'"
unbind-key -n F2

bind-key -n M-a new-window -c "#{pane_current_path}" \; rename-window "-"
bind-key -n M-\ display-panes \; split-window -h -c "#{pane_current_path}"
bind-key -n M-- display-panes \; split-window -v -c "#{pane_current_path}"
bind-key -n M-s new-session

unbind-key -n F3
unbind-key -n F4

#--------- try moving using h j k l ----------------------
# bind-key -n z-h previous-window
# bind-key -n M-l next-window
# bind-key -n M-k switch-client -p
# bind-key -n M-j switch-client -n
# bind-key -n C-S-k display-panes \; select-pane -U
# bind-key -n C-S-j display-panes \; select-pane -D
# bind-key -n C-S-h display-panes \; select-pane -L
# bind-key -n C-S-l display-panes \; select-pane -R
# bind-key -n M-S-k resize-pane -U
# bind-key -n M-S-j resize-pane -D
# bind-key -n M-S-h resize-pane -L
# bind-key -n M-S-l resize-pane -R
# bind-key -n C-S-h swap-window -t :-1
# bind-key -n C-S-l swap-window -t :+1
# -------------------------------------------------------

bind-key -n M-d run-shell 'exec touch $BYOBU_RUN_DIR/no-logout' \; detach
bind-key -n M-q kill-pane

unbind-key -n F8
# bind-key -n M-r command-prompt -p "(rename-window) " "rename-window '%%'"
bind-key -n M-r command-prompt -p "(rename-session) " "rename-session '%%'"

# try zooms
bind-key -n M-F11 break-pane
bind-key -n C-F11 join-pane -h -s :. -t :-1
bind-key -n S-F11 resize-pane -Z
