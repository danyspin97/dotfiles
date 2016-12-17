#!/usr/bin/bash

# Define the clock
Clock() {
        DATETIME=$(date "+%H:%M:%S, %a %d-%m-%Y")

        echo -n "$DATETIME"
}

# Print the clock

while true; do
        echo "%{r}%{F#FFFF00}%{B#0000FF} $(Clock) %{F-}%{B-}"
        sleep 1
    done
