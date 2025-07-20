#!/bin/sh

# Start keybinds
sxhkd &

# Wallpaper
feh --bg-scale ~/Pictures/wall.png &

# Compositor
picom &

# Reverse touchpad scrolling
xinput set-prop "SYNA7DB5:00 06CB:CD41 Touchpad" "libinput Natural Scrolling Enabled" 1
