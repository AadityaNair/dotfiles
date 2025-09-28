
####### Actual Theme Colours
set @active_window '#a9b1d6'
set @background '#1a1b26'  # In old systems, it is #16161e 
set -F @text_active '#{@background}' # To complement active_window
set @text_inactive '#c0caf5'  # In old systems, it #15161e
set -F @text_previous '#{@active_window}'  # We probably don't need this at all.
set -F @pane_border_active '#{@active_window}'  # Same as @active_window
set @pane_border_inactive '#3b4261'  # Slightly lighter than @background


####### CSS

# Clock
clock-mode-color
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
message-style
message-command-style
# message-line


# Pane
pane-active-border-style
pane-border-style
# pane-colors
# display-panes-active-color
# display-panes-color


# Popup
# popup-style
# popup-border-style


# Status
status-left-style
status-right-style
status-style


# Window 
window-status-last-style
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
status-left
status-left-length
status-right
status-right-length
# status-format
# status-justify
# status-position


# Window 
window-status-current-format
window-status-format

# TODO: Zoom indicator

# vim: ft=tmux
