#!/bin/bash

# Don't run anything here unless we have an interactive shell.
if [[ $- != *i* ]] ; then
    return
fi

source ~/.config/oil/oshrc

if [[ $(ps --no-header --pid=$PPID --format=cmd) != "fish" ]]
then
	exec fish
fi
. "$HOME/.cargo/env"

source /home/danyspin97/.config/broot/launcher/bash/br
