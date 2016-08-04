#!/usr/bin/env sh

# Terminate already running bar instances
lemonbuddy_terminate noconfirm

# Launch bar1 and bar2
lemonbuddy_wrapper bar1 &
lemonbuddy_wrapper bar2 &

echo "Bars launched..."