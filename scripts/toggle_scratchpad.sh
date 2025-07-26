#!/bin/bash

CLASS_NAME="Scratchpad"  # Change to whatever class you're using
CMD="kitty --class $CLASS_NAME -e ranger"  # or ncmpcpp or your player

# Try to find window with that class
wid=$(bspc query -N -n .window.class="$CLASS_NAME")

if [ -n "$wid" ]; then
    if [ "$wid" = "$(bspc query -N -n focused)" ]; then
        # If focused, hide it
        bspc node "$wid" --flag hidden=on
    else
        # If exists and hidden, show and focus
        bspc node "$wid" --flag hidden=off
        bspc node -f "$wid"
    fi
else
    # Set scratchpad rules and launch it
    bspc rule -a "$CLASS_NAME" state=floating sticky=on hidden=off center=on rectangle=800x500+0+0
    $CMD &
fi
