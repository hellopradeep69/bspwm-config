#!/bin/bash
SOUND="/home/hellopradeep/Sounds/Cyberpunk/Escaping from NCPD.mp3"

dunstctl set-paused false # ensure dunst is running

dbus-monitor "interface='org.freedesktop.Notifications'" |
    while read -r line; do
        if [[ "$line" =~ "member=Notify" ]]; then
            paplay "$SOUND" &
        fi
    done
