#!/usr/bin/bash

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

# Print the clock

while true; do
    echo "%{r}%{F#FFFF00}%{B#0000FF} $(RAMUsage) ┆ $(CPUusage) ┆ $(Clock) %{F-}%{B-}"
    sleep 1
done
