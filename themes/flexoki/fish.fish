# Flexoki Dark — fish syntax highlighting, pager, and prompt.
# https://stephango.com/flexoki
#
# Accents are the 400 level; see README.md in this directory for the palette
# and the 400-vs-600 rule. Sourced by fish/config.fish through fish/theme.fish.

### Syntax highlighting
set -g fish_color_normal CECDC3 # tx
set -g fish_color_command DA702C # or
set -g fish_color_keyword 879A39 # gr
set -g fish_color_quote 3AA99F # cy
set -g fish_color_redirection CE5D97 # ma
set -g fish_color_end CE5D97 # ma
set -g fish_color_error D14D41 # re
set -g fish_color_param 4385BE # bl
set -g fish_color_option 8B7EC8 # pu
set -g fish_color_escape 8B7EC8 # pu
set -g fish_color_operator 878580 # tx-2
set -g fish_color_comment 575653 # tx-3
set -g fish_color_autosuggestion 575653 # tx-3
set -g fish_color_selection --background=12253B # bl-bg-2
set -g fish_color_search_match --background=12253B # bl-bg-2

### Completion pager
set -g fish_pager_color_progress 575653 # tx-3
set -g fish_pager_color_prefix 3AA99F # cy
set -g fish_pager_color_completion CECDC3 # tx
set -g fish_pager_color_description B7B5AC # base-300
# The selected row inverts: a light background wants dark foregrounds.
set -g fish_pager_color_selected_background --background=CECDC3 # tx
set -g fish_pager_color_selected_prefix 100F0F # bg
set -g fish_pager_color_selected_completion 1C1B1A # bg-2
set -g fish_pager_color_selected_description 282726 # ui

### Prompt (fish/functions/fish_prompt.fish)
set -g __prompt_c_yellow D0A215 # ye
set -g __prompt_c_cyan 3AA99F # cy
set -g __prompt_c_red D14D41 # re
set -g __prompt_c_orange DA702C # or

# vim: ft=fish
