# Flexoki Dark — fish syntax highlighting, pager, and prompt.
# https://stephango.com/flexoki
#
# Syntax accents are the 400 level; prompt accents use the brighter 300 level.
# See README.md in this directory for the palette and the 400-vs-600 rule.
# Sourced by fish/config.fish through fish/theme.fish.

### Syntax highlighting
set -g fish_color_normal CECDC3 # tx
set -g fish_color_command 879A39 # gr
set -g fish_color_keyword DA702C # or
set -g fish_color_quote 3AA99F # cy
set -g fish_color_redirection CE5D97 # ma
set -g fish_color_end CE5D97 # ma
set -g fish_color_error D14D41 --underline # re
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
set -g __prompt_c_directory DFB431 # ye-3
set -g __prompt_c_git 5ABDAC # cy-3
set -g __prompt_c_error E8705F # re-3
set -g __prompt_c_duration A699D0 # pu-3

# vim: ft=fish
