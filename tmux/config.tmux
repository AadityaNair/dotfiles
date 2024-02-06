#!/usr/bin/env bash

/opt/homebrew/bin/tmux set -g default-terminal "xterm-256color"
tmux set-option -ga terminal-overrides ",*256col*:Tc"
tmux set -g default-command /bin/zsh

tmux set -g base-index 1
tmux set -g pane-base-index 1
tmux set -g repeat-time 0

tmux setw -g monitor-activity on
tmux set -g renumber-windows on
tmux set -g mode-keys vi
tmux set -g mouse off   # Turned off to support remote tmux sessions. Keeping it on causes problems with scrollback.
tmux set -g history-limit 30000

tmux set -g display-time 1000
tmux set -g allow-rename on
tmux set -g aggressive-resize on  # Change size of session based on the client connected to it.

# -- Change Prefix --
tmux unbind C-b
tmux set-option -g prefix C-a
tmux bind C-a send-prefix

# -- Handle Sessions --
tmux bind -n M-s new-session
tmux bind -n M-Up switch-client -p
tmux bind -n M-Down switch-client -n

tmux bind -n M-r command-prompt -p "(rename-session) " "rename-session '%%'"

# -- Handle Windows --
tmux bind -n M-a new-window -c "#{pane_current_path}"
tmux bind -n M-Right next-window
tmux bind -n M-Left previous-window

tmux bind -n S-F7 swap-window -d -t :-1
tmux bind -n S-F9 swap-window -d -t :+1
tmux bind -n M-w command-prompt -p "(rename-window) " "rename-window '%%'"

# -- Handle Splits --
tmux bind -n M-\\ split-window -h -c "#{pane_current_path}"
tmux bind -n M-- split-window -v -c "#{pane_current_path}"
tmux bind -n S-Left select-pane -L
tmux bind -n S-Right select-pane -R
tmux bind -n S-Up select-pane -U
tmux bind -n S-Down select-pane -D
tmux bind -n M-] setw synchronize-panes

tmux bind -n M-n copy-mode
tmux bind -n M-p copy-mode
tmux bind -n S-F1 copy-mode
tmux bind -n F11   copy-mode    # Just in case pg_up/down doesn't exist. Like in a macbook.
tmux bind r source-file ~/.tmux.conf

tmux bind -n M-. resize-pane -Z

tmux run '$INSTALL/dotfiles/tmux/maglev.tmux'

#vi: syntax=sh ft=sh
