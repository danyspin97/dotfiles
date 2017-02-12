#!/usr/bin/bash

#. $(dirname $0)/lemonbar_config

# Define the clock
Clock() {
    DATETIME=$(date "+%H:%M:%S, %a %d-%m-%Y")

    echo -n "$DATETIME"
}

# Get CPU usage
CPUusage() {
    USAGE=$(mpstat | awk 'FNR == 4 {print int($3)}')

    echo -n "CPU: $USAGE%"
}

RAMUsage() {
    RAM=$(free -m | awk 'FNR == 2 {print int($3 / $2 * 100)}')

    echo -n "RAM: $RAM%"
}

Battery() {
    BATTERY=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | awk /percentage/ | awk '{print $2}')

    echo -n "Bat: $BATTERY"
}

Brightness() {
    BRIGHTNESS=$(xbacklight -get | awk '{print int($1)}')

    echo -n "Brightnes: $BRIGHTNESS%"
}

while :; do
    echo "%{r}%{F#FFFFFF}%{B#FF0000} $(RAMUsage)  $(CPUusage)  $(Brightness)  $(Battery)  $(Clock) %{F-}%{B-}"
    sleep 1
done
