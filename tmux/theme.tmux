#!/usr/bin/env bash
set -e

# Optional prefix highlight plugin
tmux set -g @prefix_highlight_show_copy_mode 'on'
tmux set -g @prefix_highlight_copy_mode_attr 'fg=black,bg=yellow,bold' # default is 'fg=default,bg=yellow'


pane_border_fg=red
pane_active_border_fg=green

display_panes_active_colour=colour154
display_panes_colour=colour247
message_fg=colour16           # black
message_bg=colour11 # yellow
message_attr=bold
message_command_fg=colour16   # black
message_command_bg=colour160  # light yellow
mode_fg=colour16   # black
mode_bg=colour11 # yellow
status_fg=colour255 # white
status_bg=colour0 # dark gray
session_fg=colour16  # black
session_bg=colour11 # yellow
window_status_fg=colour255 # white
window_status_bg=colour0 # dark gray
window_status_current_fg=colour16 # black
window_status_current_bg=colour4 # blue
window_status_activity_fg=default
window_status_activity_bg=default
window_status_activity_attr=underscore
window_status_bell_fg=colour11 # yellow
window_status_bell_bg=default
window_status_bell_attr=blink,bold
window_status_last_fg=colour4 # blue


apply_theme() {
    left_separator=''
    left_separator_black=''
    session_symbol=''
    
    #### Panes 
    tmux set -g pane-border-style fg=$pane_border_fg \; set -g pane-active-border-style fg=$pane_active_border_fg
    #uncomment for fat borders
    #tmux set -ga pane-border-style bg=$pane_border_fg \; set -ga pane-active-border-style bg=$pane_active_border_fg

    tmux set -g display-panes-active-colour $display_panes_active_colour \; set -g display-panes-colour $display_panes_colour

    # messages
    tmux set -g message-style fg=$message_fg,bg=$message_bg,$message_attr

    tmux set -g message-command-style fg=$message_command_fg,bg=$message_command_bg,$message_attr

    # windows mode
    mode_attr=bold
    tmux setw -g mode-style fg=$mode_fg,bg=$mode_bg,$mode_attr

    # status line
    tmux set -g status-style fg=$status_fg,bg=$status_bg

    status_left="#[fg=$session_fg,bg=$session_bg] ❐ #S #[fg=$session_bg,bg=$status_bg]$left_separator_black"
    if [ x"`tmux -q -L tmux_theme_status_left_test -f /dev/null new-session -d \; show -g -v status-left \; kill-session`" = x"[#S] " ] ; then
        status_left="$status_left "
    fi
    tmux set -g status-left-length 32 \; set -g status-left "$status_left"

    window_status_last_attr=default
    window_status_format="#I $left_separator #W  "
    tmux setw -g window-status-style fg=$window_status_fg,bg=$window_status_bg \; setw -g window-status-format "$window_status_format"

    window_status_current_format="#[fg=$window_status_bg,bg=$window_status_current_bg]$left_separator_black#[fg=$window_status_current_fg,bg=$window_status_current_bg] #I $left_separator #W #[fg=$window_status_current_bg,bg=$status_bg,nobold]$left_separator_black"
    tmux setw -g window-status-current-format "$window_status_current_format"
    tmux set -g status-justify left

    tmux setw -g window-status-activity-style fg=$window_status_activity_fg,bg=$window_status_activity_bg,$window_status_activity_attr

    tmux setw -g window-status-bell-style fg=$window_status_bell_fg,bg=$window_status_bell_bg,$window_status_bell_attr

    tmux setw -g window-status-last-style $window_status_last_attr,fg=$window_status_last_fg


    tmux set -g status-right-length 64 \; set -g status-right ""

    # clock
    clock_mode_colour=colour4 # blue
    tmux setw -g clock-mode-colour $clock_mode_colour
}

apply_theme
