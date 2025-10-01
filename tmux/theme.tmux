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

set -g @window-activity-style '#[curly-underscore]'
set -g @window-zoom-style '#[double-underscore]'
set -g window-status-activity-style ''  # How to style a window with activity. Needs to be empty because we set it in the format itself.

set -g status-justify centre  # Where to put window list. left|right|centre|absolute-centre
set -g window-status-format "#{?window_index,#{@separator},} #{?window_zoomed_flag,#{@window-zoom-style},}#{?window_activity_flag,#{@window-activity-style},}#{window_name}"
set -g window-status-current-format "#{?window_index,#{@separator},} #{?window_zoomed_flag,#{@window-zoom-style},}#[fg=#{@background},bg=#{@active_window},italics]#{window_name}"

######### Status Right
set -g status-right " %a, %b %d  %H:%M"  # Format for the right side of the status bar.
set -g status-right-style 'italics'
set -g status-right-length 64


############################### Panes
set -g pane-border-indicators arrows  # How to indicate active panes. off|colour|arrows|both
set -g pane-border-status off  # Adds a status line to each pane. Needs work before deploying.

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
# message-line  # I dunno what this changes when there is only one line status. 
# pane-active-border-style  # With arrows, only this style is used. Unnecessary when fg=@active_window.
# pane-border-format ''  # Format of the pane border. Useful only when enabled.
# pane-border-lines  # How does the border look when not covered by above format. Useful only when enabled.
# pane-border-style  # Useless when using arrows; only pane-active-border-style is applied.
# pane-colors  # Define colour pallete (ie colour1..255) for a pane.
# status-format  # Specify the format for each line of the status. We have only one line and we define it separately.
# window-active-style  # Sets colour for the active window/pane.
# window-status-bell-style  # Window status for bell alerts. We have disabled bell alerts
# window-status-current-style # Unnecessary in the current setup because we have to manually define the colours in format again.
# window-status-last-style  # Style the last active window. We don't want to make that distinction.
# window-status-style  # This is set directly in the format and hence un-needed.
# window-style  # Sets colour for the whole window/pane.

# TODO: mode-style
# TODO: Different UI when name has been edited.
# vim: ft=tmux
