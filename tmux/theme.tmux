####### Actual Theme Colours
set -g @active_window '#7aa2f7'
set -g @background '#1a1b26'

################################ Status Bar

set -g status-position bottom  # The other option is top.
set -gF status-style 'fg=#{@active_window},bg=#{@background}'  # Default theme for the entire status line.

######### Status Left 
set -g status-left "#{session_name}"
set -g status-left-length 32  # Maximum length of the left component of the status-line
set -gF status-left-style 'fg=#{@active_window}, italics, bold'

######### Window List
set -g @separator '#[fg=#{active_window},bg=#{@background}]|#[default]'
set -g status-justify centre  # Where to put window list. left|right|centre|absolute-centre
set -g window-status-format "#{?window_index,#{@separator},} #{window_name}"  # Default format of the window list.
# window-status-style

set -g window-status-current-format "#{?window_index,#{@separator},} #[fg=#{@background},bg=#{@active_window},italics]#{window_name}"  # Format for the the current window.
set -gF window-status-activity-style 'underscore'  # How to style a window with activity.

######### Status Right
set -g status-right " %a, %b %d  %H:%M"  # Format for the right side of the status bar.
set -g status-right-style 'italics'
set -g status-right-length 64


############################### Panes
set -g pane-border-indicators arrows  # How to indicate active panes. off|colour|arrows|both

# pane-border-format
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
set -gF message-style "fg=#{@active_window},bg=#{@background},bold"
# message-line

######### Popups
# popup-style
# popup-border-style
# popup-border-lines

######### Unordered
# clock-mode-style
# cursor-color
# cursor-style

######### Definitely not needed
# clock-mode-color  # Colour when we start the clock. We already have clock in the status-bar
# message-command-style  # I found no case where we call message-command-style. Something command mode + vi mode. 
# pane-active-border-style  # With arrows, only this style is used. Unnecessary when fg=@active_window.
# pane-border-style  # Useless when using arrows; only pane-active-border-style is applied.
# pane-colors  # Define colour pallete (ie colour1..255) for a pane.
# status-format  # Specify the format for each line of the status. We have only one line and we define it separately.
# window-active-style  # Sets colour for the active window/pane.
# window-status-bell-style  # Window status for bell alerts. We have disabled bell alerts
# window-status-current-style # Unnecessary in the current setup because we have to manually define the colours in format again.
# window-status-last-style  # Style the last active window. We don't want to make that distinction.
# window-style  # Sets colour for the whole window/pane.

# TODO: mode-style
# TODO: Zoom indicator
# TODO: Different UI when name has been edited.

# vim: ft=tmux
