# TokyoNight Night — fish syntax highlighting, pager, and prompt.
#
# Sourced by fish/config.fish through fish/theme.fish. Keeps the same set of
# keys as every other theme here, so re-sourcing over another theme cannot
# leave its values behind.

### Syntax highlighting
set -g fish_color_normal c0caf5
set -g fish_color_command 7dcfff
set -g fish_color_keyword bb9af7
set -g fish_color_quote e0af68
set -g fish_color_redirection c0caf5
set -g fish_color_end ff9e64
set -g fish_color_error f7768e
set -g fish_color_param 9d7cd8
set -g fish_color_option bb9af7
set -g fish_color_escape bb9af7
set -g fish_color_operator 9ece6a
set -g fish_color_comment 565f89
set -g fish_color_autosuggestion 565f89
set -g fish_color_selection --background=283457
set -g fish_color_search_match --background=283457

### Completion pager
set -g fish_pager_color_progress 565f89
set -g fish_pager_color_prefix 7dcfff
set -g fish_pager_color_completion c0caf5
set -g fish_pager_color_description 565f89
# The selected row keeps a dark background, so the foregrounds stay light.
# Description is 9aa5ce rather than the 565f89 used above, which would sit at
# roughly 1.9:1 against this background.
set -g fish_pager_color_selected_background --background=283457
set -g fish_pager_color_selected_prefix 7dcfff
set -g fish_pager_color_selected_completion c0caf5
set -g fish_pager_color_selected_description 9aa5ce

### Prompt (fish/functions/fish_prompt.fish)
set -g __prompt_c_yellow e0af68
set -g __prompt_c_cyan 2ac3de
set -g __prompt_c_red f7768e
set -g __prompt_c_orange ff9e64

# vim: ft=fish
