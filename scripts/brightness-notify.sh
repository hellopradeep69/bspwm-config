#!/bin/bash
brightnessctl set "$1"
level=$(brightnessctl | grep -oP '\(\K[0-9]+(?=%\))')
notify-send -u low "🔆 Brightness" "$level%"
