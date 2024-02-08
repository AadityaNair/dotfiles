#!/usr/bin/env bash
set -e

# Optional prefix highlight plugin
tmux set -g @prefix_highlight_show_copy_mode 'on'
tmux set -g @prefix_highlight_copy_mode_attr 'fg=black,bg=yellow,bold' # default is 'fg=default,bg=yellow'

#------------------------------------------ Maglev Theme -----------------------------
display_panes_active_colour=colour154
display_panes_colour=colour247
message_bg=colour11 # yellow
message_command_bg=colour160  # light yellow
message_command_fg=colour16   # black
message_fg=colour16           # black
mode_bg=colour11 # yellow
mode_fg=colour16   # black
pane_active_border_fg=green
pane_border_fg=red
session_bg=colour11 # yellow
session_fg=colour16  # black
status_bg=colour0 # dark gray
status_fg=colour255 # white
window_status_activity_bg=default
window_status_activity_fg=default
window_status_bell_bg=default
window_status_bell_fg=colour11 # yellow
window_status_bg=colour0 # dark gray
window_status_current_bg=colour4 # blue
window_status_current_fg=colour16 # black
window_status_fg=colour255 # white
window_status_last_fg=colour4 # blue
clock_mode_colour=colour4 # blue

#----------------------------------------- TokyoNight Night Theme ------------------------
pane_active_border_fg='#7aa2f7'
pane_border_fg='#3b4261'
message_fg=$pane_active_border_fg
message_bg=$pane_border_fg
message_command_bg=$message_bg
message_command_fg=$message_fg
mode_bg=$pane_border_fg
mode_fg=$pane_active_border_fg
session_bg=$pane_active_border_fg
session_fg='#15161e'
status_bg='#16161e'
status_fg=$pane_active_border_fg
window_status_activity_bg=$status_bg
window_status_activity_fg='#a9b1d6'
window_status_bg=$status_bg
window_status_fg=$window_status_activity_fg


window_status_current_bg=colour4 # blue
window_status_current_fg=colour16 # black

# These don't exist
# display_panes_colour=colour247
# display_panes_active_colour=colour154
# window_status_bell_bg=default
# window_status_bell_fg=colour11 # yellow
# window_status_last_fg=colour4 # blue
# clock_mode_colour=colour4 # blue

#----------------------------------------- Actual Theme --------------------------------

message_attr=bold
mode_attr=bold
window_status_bell_attr=blink,bold
window_status_last_attr=default
window_status_activity_attr=underscore

left_separator=''
left_separator_black=''
session_symbol=''

tmux set -g pane-border-style fg=$pane_border_fg \; set -g pane-active-border-style fg=$pane_active_border_fg
#uncomment for fat borders
#tmux set -ga pane-border-style bg=$pane_border_fg \; set -ga pane-active-border-style bg=$pane_active_border_fg

tmux set -g display-panes-active-colour $display_panes_active_colour \; set -g display-panes-colour $display_panes_colour
tmux set -g message-style fg=$message_fg,bg=$message_bg,$message_attr
tmux set -g message-command-style fg=$message_command_fg,bg=$message_command_bg,$message_attr
tmux setw -g mode-style fg=$mode_fg,bg=$mode_bg,$mode_attr
tmux set -g status-style fg=$status_fg,bg=$status_bg

status_left="#[fg=$session_fg,bg=$session_bg] #S #[fg=$session_bg,bg=$status_bg]$left_separator_black"
tmux set -g status-left-length 32 \; set -g status-left "$status_left"

window_status_format="#I $left_separator #W  "
tmux setw -g window-status-style fg=$window_status_fg,bg=$window_status_bg \; setw -g window-status-format "$window_status_format"

window_status_current_format="#[fg=$window_status_bg,bg=$window_status_current_bg]$left_separator_black#[fg=$window_status_current_fg,bg=$window_status_current_bg] #I $left_separator #W #[fg=$window_status_current_bg,bg=$status_bg,nobold]$left_separator_black"
tmux setw -g window-status-current-format "$window_status_current_format"
tmux set -g status-justify left

tmux setw -g window-status-activity-style fg=$window_status_activity_fg,bg=$window_status_activity_bg,$window_status_activity_attr
tmux setw -g window-status-bell-style fg=$window_status_bell_fg,bg=$window_status_bell_bg,$window_status_bell_attr
tmux setw -g window-status-last-style $window_status_last_attr,fg=$window_status_last_fg


tmux set -g status-right-length 64 \; set -g status-right ""
tmux setw -g clock-mode-colour $clock_mode_colour

