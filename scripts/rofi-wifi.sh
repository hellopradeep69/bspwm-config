#!/bin/bash

# Get list of Wi-Fi networks (skip header)
networks=$(nmcli -f SSID,SECURITY device wifi list | awk 'NR>1 {print $1}' | uniq)

# Show in Rofi
chosen=$(echo "$networks" | rofi -dmenu -i -p "Select Wi-Fi")

# If nothing selected, exit
[ -z "$chosen" ] && exit

# Check if network requires password
secured=$(nmcli -f SSID,SECURITY device wifi list | grep -w "$chosen" | awk '{print $2}')

# Ask for password if secured
if [[ "$secured" != "--" && "$secured" != "" ]]; then
    password=$(rofi -dmenu -password -p "Enter password for $chosen")
    [ -z "$password" ] && exit
    nmcli device wifi connect "$chosen" password "$password"
else
    nmcli device wifi connect "$chosen"
fi
