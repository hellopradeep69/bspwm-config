#!/bin/bash

# Settings
CRITICAL_LEVEL=30
CHECK_INTERVAL=60 # seconds

# Loop forever
while true; do
    # Get battery percentage (compatible with most Linux distros)
    battery_level=$(cat /sys/class/power_supply/BAT*/capacity)
    charging_status=$(cat /sys/class/power_supply/BAT*/status)

    if [[ "$battery_level" -le "$CRITICAL_LEVEL" && "$charging_status" != "Charging" ]]; then
        notify-send -u critical "⚠️ Low Battery" "Battery is at ${battery_level}%!"
    fi

    sleep "$CHECK_INTERVAL"
done
