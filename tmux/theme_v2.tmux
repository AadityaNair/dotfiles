
####### Actual Theme Colours
set -g @active_window '#a9b1d6'
set -g @background '#1a1b26'  # In old systems, it is #16161e 
set -gF @text_active '#{@background}' # To complement active_window
set -g @text_inactive '#c0caf5'  # In old systems, it #15161e
set -gF @text_previous '#{@active_window}'  # We probably don't need this at all.
set -gF @pane_border_active '#{@active_window}'  # Same as @active_window
set -g @pane_border_inactive '#3b4261'  # Slightly lighter than @background

set -gF @other_utils '#{@active_window}'


####### CSS

# Clock
set -gF clock-mode-color "#{@other_utils}"
# clock-mode-style


# Copy
# copy-mode-match-style
# copy-mode-mark-style
# copy-mode-current-match-style


# Cursor
# cursor-color


# Menu
# menu-style
# menu-selected-style
# menu-border-style
# menu-border-lines


# Message
set -gF message-style "fg=#{@active_window},bg=#{@pane_border_inactive},bold"
set -gF message-command-style "fg=#{@active_window},bg=#{@pane_border_inactive},bold"
# message-line


# Pane
set -gF pane-border-style 'fg=#{@pane_border_active}'
set -gF pane-active-border-style 'fg=#{@pane_border_inactive}'
# pane-colors
# display-panes-active-color
# display-panes-color


# Popup
# popup-style
# popup-border-style


# Status
set -gF status-style 'fg=#{@active_window},bg=#{@background}'
# set status-left-style ''
# set status-right-style ''


# Window 
set -gF window-status-last-style 'fg=#{@active_window},default'
# window-active-style
# window-status-activity-style
# window-status-bell-style
# window-status-current-style


####### HTML

# Clock
# Copy


# Cursor
# cursor-style


# Menu
# Message


# Pane
# pane-border-format
# pane-border-indicators
# pane-border-status
# pane-border-lines


# Popup
# popup-border-lines


# Status
set -gF status-left "#[fg=#{@text_active},bg=#{@active_window}] #S #[fg=#{@active_window},bg=#{@active_window}]"
set -g status-right "#[italics] %a, %b %d  %H:%M"
set -g status-left-length 32
set -g status-right-length 64
# status-format
# status-justify
# status-position


# Window 
set -gF window-status-current-format "#[fg=#{@background},bg=#{@active_window}]#[fg=#{@background},bg=#{@active_window}] #I  #W #[fg=#{@active_window},bg=#{@active_window},nobold]"
set -g window-status-format "#I  #W  "

# TODO: Zoom indicator

# vim: ft=tmux
