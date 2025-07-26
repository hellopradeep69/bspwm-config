#!/bin/bash
state=$(xset q | grep "Caps Lock:" | awk '{print $4}')
if [ "$state" == "on" ]; then
    notify-send -u low "⇪ Caps Lock" "Enabled"
else
    notify-send -u low "⇪ Caps Lock" "Disabled"
fi
