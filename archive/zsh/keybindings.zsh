################# MODIFY COMMANDS ####################

sudo-command-line() {
        [[ -z $BUFFER ]] && zle up-history
            [[ $BUFFER != sudo\ * ]] && LBUFFER="sudo $LBUFFER"
}
zle -N sudo-command-line
bindkey "\e\e" sudo-command-line


################# MOVEMENTS ##################
# TODO: Reorganise commands.
# Research the docs:
#   - http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html
#   - http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Zle-Builtins
#   - http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Standard-Widgets

#bindkey "^[[1~" beginning-of-line
#bindkey "^[[4~" end-of-line
#bindkey "^[[3~" delete-char
bindkey "\ei" insert-last-word

# Adding below because for some fucking reason zsh replaced a lot of these with self-insert
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^U" kill-whole-line
bindkey "^Y" yank
bindkey "^B" backward-word # This is a new keybinding

bindkey "^H" backward-kill-word # This also maps to Ctrl+Bcksp
bindkey "^[[1;5D" backward-word # Ctrl+Left
bindkey "^[[1;5C" forward-word  # Ctrl+Right

bindkey "^K" kill-line

# bindkey <something> quote-region
# bindkey <something> transpose-words
# Something to directly edit a file
