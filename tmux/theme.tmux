
####### Actual Theme Colours
set -g @active_window '#7aa2f7'
set -g @text_inactive '#c0caf5'  # In old systems, it #15161e
set -g @background '#1a1b26'  # In old systems, it is #16161e 
set -g @pane_border_inactive '#3b4261'  # Slightly lighter than @background

set -gF @text_active '#{@background}' # To complement active_window
set -gF @text_previous '#{@active_window}'  # We probably don't need this at all.
set -gF @pane_border_active '#{@active_window}'  # Same as @active_window
set -gF @other_utils '#{@active_window}'


################################ Status Bar

set -gF status-style 'fg=#{@active_window},bg=#{@background}'
set -g status-justify left  # Where to put window list. left|right|center|absolute-center
# status-format  # Specify the format for each line of the status.
# status-position

######### Status Left
# set status-left-style ''
set -g status-left "#[fg=#{@background},bg=#{@active_window}] #S #[fg=#{@active_window},bg=#{@background}]"
set -g status-left-length 32  # Maximum length of the left component of the status-line

######### Window List
set -gF window-status-last-style 'fg=#{@active_window},default'
# TODO: window-status-activity-style
# TODO: window-status-bell-style
# TODO: window-status-style
# window-active-style
# window-status-current-style
set -g window-status-current-format "#[fg=#{@background},bg=#{@active_window}]#[fg=#{@background},bg=#{@active_window}] #I  #W #[fg=#{@active_window},bg=#{@background},nobold]"
set -g window-status-format "#I  #W  "
# TODO: Use -a to split into multiple-lines

######### Status Right
# set status-right-style ''
set -g status-right "#[italics] %a, %b %d  %H:%M" 
set -g status-right-length 64



############################### Panes
set -gF pane-border-style 'fg=#{@pane_border_inactive}'
set -gF pane-active-border-style 'fg=#{@active_window}'
# TODO: set -gF display-panes-active-color ""
# TODO: set -gF display-panes-color ""
# pane-colors

# pane-border-format
# pane-border-indicators
# pane-border-status
# pane-border-lines


############################### Others

######### Copy Mode
# copy-mode-match-style
# copy-mode-mark-style
# copy-mode-current-match-style

######### Menu
# menu-style
# menu-selected-style
# menu-border-style
# menu-border-lines

######### Message
set -gF message-style "fg=#{@active_window},bg=#{@pane_border_inactive},bold"
set -gF message-command-style "fg=#{@active_window},bg=#{@pane_border_inactive},bold"
# message-line

######### Popups
# popup-style
# popup-border-style
# popup-border-lines

######### Unordered
set -gF clock-mode-color "#{@other_utils}"
# clock-mode-style
# cursor-color
# cursor-style

# TODO: mode-style
# TODO: Zoom indicator
# TODO: Different UI when name has been edited.

# vim: ft=tmux
