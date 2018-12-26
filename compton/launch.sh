#! /usr/bin/env bash

killall -q compton
while pgrep -u $UID -x compton >/dev/null; do sleep 1; done
compton --daemon --config $HOME/.dotfiles/compton/compton.conf 
