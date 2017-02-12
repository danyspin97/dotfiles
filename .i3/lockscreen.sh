#!bin/bash

# Turn off screen after 90 seconds
exec xset dpms 90 0 300

exec xautolock -detectsleep \
    -time 3 -locker "i3lock-fancy" \
    -notify 30 \
    -notifier "notify-send -u critical -t 1000 -- 'Locking screen in 30 seconds'"
