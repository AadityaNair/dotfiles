####### Actual Theme Colours
set -g @text-inactive '#a9b1d6'
set -g @background-primary '#24283b'
set -g @background-active '#7dcfff'
set -g @separator-color '#bb9af7'
set -g @session '#9aa5ce'
set -g @time "#2ac3de"
set -g @message "#f7768e"
set -g @activity "#ff9e64"
set -g @border-pane "#73daca"
set -g @copy-mark-bg "#f7768e"

set -gF @zoom '#{@border-pane}'
set -gF @date '#{@session}'
set -gF @text-active '#{@background-primary}'
set -gF @copy-mark-fg '#{@background-primary}'



################################ Status Bar

set -g status-position bottom  # The other option is top.
set -gF status-style 'bg=#{@background-primary}'  # Default theme for the entire status line.

######### Status Left
set -g status-left "#{session_name}"
set -g status-left-length 32
set -gF status-left-style 'fg=#{@session}, italics, bold'

######### Window List
set -gF @separator '#[fg=#{@separator-color}]|#[default]'

set -gF @window-activity-style '#[us=#{@activity},curly-underscore]'
set -gF @window-zoom-style '#[us=#{@zoom},double-underscore]'

set -g status-justify centre

set -g window-status-format "\
#{?window_index,#{@separator},} \
#{?window_zoomed_flag,#{@window-zoom-style},}\
#{?window_activity_flag,#{@window-activity-style},}\
#[fg=#{@text-inactive}]#{window_name}\
"

set -g window-status-current-format "\
#{?window_index,#{@separator},} \
#{?window_zoomed_flag,#{@window-zoom-style},}\
#[fg=#{@text-active},bg=#{@background-active},italics,bold]#{window_name}"

######### Status Right
set -g status-right "#[fg=#{@date},italics] %a, %b %d  #[fg=#{@time}]%H:%M"
set -g status-right-length 64


############################### Panes
set -g pane-border-indicators arrows  # How to indicate active panes. off|colour|arrows|both
set -g pane-border-status off  # Adds a status line to each pane. Needs work before deploying.
set -g pane-active-border-style 'fg=#{@border-pane}'


############################### Others

######### Message
set -gF message-style "fg=#{@message},italics"

######### Copy Mode
set -g copy-mode-mark-style 'fg=#{@copy-mark-fg},bg=#{@copy-mark-bg}'
# copy-mode-match-style
# copy-mode-current-match-style

######### Menu
# menu-style
# menu-selected-style
# menu-border-style
# menu-border-lines

######### Popups
# popup-style
# popup-border-style
# popup-border-lines

######### Unordered
# clock-mode-style
# cursor-color
# cursor-style
# display-panes-active-color  # Colour for the active pane in :display-panes command.
# display-panes-color  # Colour for the :display-panes command.

######### Definitely not needed
# clock-mode-color  # Colour when we start the clock. We already have clock in the status-bar
# message-command-style  # I found no case where we call message-command-style. Something command mode + vi mode. 
# message-line  # I dunno what this changes when there is only one line status. 
# pane-active-border-style  # With arrows, only this style is used.
# pane-border-format ''  # Format of the pane border. Useful only when enabled.
# pane-border-lines  # How does the border look when not covered by above format. Useful only when enabled.
# pane-border-style  # Useless when using arrows; only pane-active-border-style is applied.
# pane-colors  # Define colour pallete (ie colour1..255) for a pane.
# status-format  # Specify the format for each line of the status. We have only one line and we define it separately.
# status-right-style  # We set the style directly in the format.
# window-active-style  # Sets colour for the active window/pane.
# window-status-activity-style ''  # How to style a window with activity. Specified in the format itself.
# window-status-bell-style  # Window status for bell alerts. We have disabled bell alerts
# window-status-current-style # Unnecessary in the current setup because we have to manually define the colours in format again.
# window-status-last-style  # Style the last active window. We don't want to make that distinction.
# window-status-style  # This is set directly in the format and hence un-needed.
# window-style  # Sets colour for the whole window/pane.

# TODO: mode-style
# TODO: Different UI when name has been edited.
# vim: ft=tmux
