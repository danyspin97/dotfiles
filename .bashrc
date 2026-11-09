#!/bin/bash

# Don't run anything here unless we have an interactive shell.
if [[ $- != *i* ]] ; then
    return
fi

session="$(ps --no-header --pid=$PPID --format=cmd)"
if [[ -n "$session" && "$session" != "fish" ]]
then
	exec fish
fi
