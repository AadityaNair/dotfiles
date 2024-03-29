#!/usr/bin/env bash

# TokyoNight colors for Tmux

tmux set -g mode-style "fg=#7aa2f7,bg=#3b4261"

tmux set -g message-style "fg=#7aa2f7,bg=#3b4261"
tmux set -g message-command-style "fg=#7aa2f7,bg=#3b4261"

tmux set -g pane-border-style "fg=#3b4261"
tmux set -g pane-active-border-style "fg=#7aa2f7"

tmux set -g status "on"
tmux set -g status-justify "left"

tmux set -g status-style "fg=#7aa2f7,bg=#16161e"

tmux set -g status-left-length "100"
tmux set -g status-right-length "100"

tmux set -g status-left-style NONE
tmux set -g status-right-style NONE

tmux set -g status-left "#[fg=#15161e,bg=#7aa2f7,bold] #S #[fg=#7aa2f7,bg=#16161e,nobold,nounderscore,noitalics]"
tmux set -g status-right "#[fg=#16161e,bg=#16161e,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#16161e] #{prefix_highlight} #[fg=#3b4261,bg=#16161e,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#3b4261] %Y-%m-%d  %I:%M %p #[fg=#7aa2f7,bg=#3b4261,nobold,nounderscore,noitalics]#[fg=#15161e,bg=#7aa2f7,bold] #h "
tmux if-shell '[ "$(tmux show-option -gqv "clock-mode-style")" == "24" ]' {
  set -g status-right "#[fg=#16161e,bg=#16161e,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#16161e] #{prefix_highlight} #[fg=#3b4261,bg=#16161e,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#3b4261] %Y-%m-%d  %H:%M #[fg=#7aa2f7,bg=#3b4261,nobold,nounderscore,noitalics]#[fg=#15161e,bg=#7aa2f7,bold] #h "
}

tmux setw -g window-status-activity-style "underscore,fg=#a9b1d6,bg=#16161e"
tmux setw -g window-status-separator ""
tmux setw -g window-status-style "NONE,fg=#a9b1d6,bg=#16161e"
tmux setw -g window-status-format "#[fg=#16161e,bg=#16161e,nobold,nounderscore,noitalics]#[default] #I  #W #F #[fg=#16161e,bg=#16161e,nobold,nounderscore,noitalics]"
tmux setw -g window-status-current-format "#[fg=#16161e,bg=#3b4261,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#3b4261,bold] #I  #W #F #[fg=#3b4261,bg=#16161e,nobold,nounderscore,noitalics]"

# tmux-plugins/tmux-prefix-highlight support
tmux set -g @prefix_highlight_output_prefix "#[fg=#e0af68]#[bg=#16161e]#[fg=#16161e]#[bg=#e0af68]"
tmux set  -g @prefix_highlight_output_suffix ""
