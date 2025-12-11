#!/bin/bash

# Don't run anything here unless we have an interactive shell.
if [[ $- != *i* ]] ; then
    return
fi

source ~/.config/oil/oshrc

session="$(ps --no-header --pid=$PPID --format=cmd)"
if [[ -n "$session" && "$session" != "fish" ]]
then
	exec fish
fi
#. "$HOME/.cargo/env"

#source /home/danyspin97/.config/broot/launcher/bash/br

. "$XDG_DATA_HOME"/xdg-apply/aliases

source /home/danyspin97/.config/broot/launcher/bash/br
