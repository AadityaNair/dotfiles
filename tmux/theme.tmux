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

# status-format  # Specify the format for each line of the status.
# status-position

######### Status Left
set -g status-left "#[fg=#{@background},bg=#{@active_window}] #S #[fg=#{@active_window},bg=#{@background}]"
set -g status-left-length 32  # Maximum length of the left component of the status-line
# set status-left-style ''

######### Window List
set -g status-justify left  # Where to put window list. left|right|center|absolute-center
set -g window-status-format "#I  #W "  # Default format of the window list.
set -gF status-style 'fg=#{@active_window},bg=#{@background}'  # Default theme for the window list (I think)

set -g window-status-current-format "#[fg=#{@background},bg=#{@active_window}]#[fg=#{@background},bg=#{@active_window}] #I  #W #[fg=#{@active_window},bg=#{@background},nobold]"  # Format for the the current window.
set -gF window-status-last-style 'fg=#{@active_window},default'  # How to style the last active window.
set -gF window-status-activity-style 'fg=#{@active_window},underscore'  # How to style a window with activity.

# window-status-style
# window-active-style
# window-status-current-style
# TODO: Use -a to split into multiple-lines

######### Status Right
set -g status-right "#[italics] %a, %b %d  %H:%M"  # Format for the right side of the status bar.
set -g status-right-length 64
# set status-right-style ''



############################### Panes
set -gF pane-border-style 'fg=#{@pane_border_inactive}'  # Border for the inactive panes.
set -gF pane-active-border-style 'fg=#{@active_window}'  # Border for the active pane. # TODO: Not useful with arrows

# pane-border-format
set -g pane-border-indicators arrows  # How to indicate active panes. off|colour|arrows|both
# pane-border-status
# pane-border-lines

# set -gF display-panes-color ""   # Colour for the :display-panes command.
# set -gF display-panes-active-color ""  # Colour for the active pane in :display-panes command.

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
set -gF clock-mode-color "#{@other_utils}"  # Colour when we start the clock. Probably unnecessary.
# clock-mode-style
# cursor-color
# cursor-style

######### Definitely not needed
# pane-colors  # Define colour pallete (ie colour1..255) for a pane.
# window-status-bell-style  # Window status for bell alerts. We have disabled bell alerts

# TODO: mode-style
# TODO: Zoom indicator
# TODO: Different UI when name has been edited.

# vim: ft=tmux
