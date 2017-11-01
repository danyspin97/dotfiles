#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

# Get monitors suitable for the bar
POLYBAR_OUTPUT=$(polybar -m | awk '{ print substr($1, 1, length($1) - 1) }')

# If there is only one monitor
if [ $(echo $POLYBAR_OUTPUT | wc -l) = 1 ]; then
    # then set the bar there
    POLYBAR_MONITOR=$POLYBAR_OUTPUT
else
    # Is there a primary monitor?
    PRIMARY=$(xrandr --listactivemonitors | grep \* | awk '{ print $4 }')
    if [ $PRIMARY == "" ]; then
        # Set the bar on the first monitor suitable
        POLYBAR_MONITOR=$(echo $POLYBAR_OUTPUT | head -n 1)
    else
        # Set the bar on the primary monitor
        POLYBAR_MONITOR=$PRIMARY
    fi
fi

export POLYBAR_MONITOR

# Launch bar1 and bar2
polybar top &
polybar bottom &

echo "Bar launched..."
