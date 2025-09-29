
####### Actual Theme Colours
set -g @active_window '#7aa2f7'
set -g @text_inactive '#c0caf5'  # In old systems, it #15161e
set -g @background '#1a1b26'  # In old systems, it is #16161e 
set -g @pane_border_inactive '#3b4261'  # Slightly lighter than @background

set -gF @text_active '#{@background}' # To complement active_window
set -gF @text_previous '#{@active_window}'  # We probably don't need this at all.
set -gF @pane_border_active '#{@active_window}'  # Same as @active_window
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
set -gF pane-border-style 'fg=#{@pane_border_inactive}'
set -gF pane-active-border-style 'fg=#{@active_window}'
# TODO: set -gF display-panes-active-color ""
# TODO: set -gF display-panes-color ""
# pane-colors


# Popup
# popup-style
# popup-border-style


# Status
set -gF status-style 'fg=#{@active_window},bg=#{@background}'
# set status-left-style ''
# set status-right-style ''


# Window 
set -gF window-status-last-style 'fg=#{@active_window},default'
# TODO: window-status-activity-style
# TODO: window-status-bell-style
# TODO: window-status-style
# window-active-style
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
set -g status-left "#[fg=#{@background},bg=#{@active_window}] #S #[fg=#{@active_window},bg=#{@background}]"
set -g status-right "#[italics] %a, %b %d  %H:%M"
set -g status-left-length 32
set -g status-right-length 64
set -g status-justify left
# status-format
# status-position


# Window 
set -g window-status-current-format "#[fg=#{@background},bg=#{@active_window}]#[fg=#{@background},bg=#{@active_window}] #I  #W #[fg=#{@active_window},bg=#{@background},nobold]"
set -g window-status-format "#I  #W  "

# TODO: mode-style
# TODO: Zoom indicator
# TODO: Different UI when name has been edited.

# vim: ft=tmux
