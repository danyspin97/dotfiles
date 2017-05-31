#!/usr/bin/sh

# Turn off screen after 90 seconds
xset dpms 240 240 240

xautolock -enable \
    -detectsleep \
    -time 3 \
    -locker "i3lock-fancy" \
    -notify 30 \
    -notifier "notify-send -u critical -t 1000 'Locking screen in 30 seconds'" &
