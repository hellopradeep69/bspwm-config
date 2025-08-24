#!/usr/bin/env bash
# rofi-wifi.sh — Wi-Fi picker for nmcli + rofi (Polybar-safe)

set -u

LOGFILE="/tmp/rofi-wifi.log"
# Ensure common paths when run from Polybar
export PATH="/usr/local/bin:/usr/bin:/bin:$PATH"

# Find wifi device (first wifi device)
wifi_dev="$(nmcli -t -f DEVICE,TYPE device | awk -F: '$2=="wifi"{print $1; exit}')"

if [ -z "${wifi_dev:-}" ]; then
    notify-send "Wi-Fi" "No Wi-Fi device found"
    exit 1
fi

wifi_state="$(nmcli -t -f WIFI general status | head -n1)" # enabled/disabled
active_ssid="$(nmcli -t -f NAME,DEVICE connection show --active | awk -F: -v d="$wifi_dev" '$2==d{print $1; exit}')"

# Build list (tab-separated to avoid parsing issues)
# Format shown in rofi: "SSID<TAB>signal% [SEC]" (SSID may be empty/hidden)
scan_list() {
    nmcli -t --rescan yes -f SSID,SECURITY,SIGNAL dev wifi list |
        awk -F: 'length($1){ printf "%s\t%s%% [%s]\n", $1, $3, ($2==""?"OPEN":$2) }' |
        sort -u
}

menu="$(mktemp)"
{
    echo -e "\tRescan"
    if [ "$wifi_state" = "enabled" ]; then
        echo -e "直\tDisable Wi-Fi"
    else
        echo -e "直\tEnable Wi-Fi"
    fi
    if [ -n "${active_ssid:-}" ]; then
        echo -e "\tDisconnect ($active_ssid)"
    fi
    echo "───────────────"
    scan_list
} >"$menu"

# Show with rofi (tab-separated columns)
choice="$(column -t -s $'\t' "$menu" | rofi -dmenu -i -p "Wi-Fi" 2>>"$LOGFILE")" || {
    rm -f "$menu"
    exit 0
}
rm -f "$menu"

# Map back to raw line (get first field = SSID)
# Because we used a header with symbols, handle those first:
case "$choice" in
*"Rescan"*)
    nmcli dev wifi rescan >>"$LOGFILE" 2>&1
    exit 0
    ;;
*"Enable Wi-Fi"*)
    nmcli r wifi on >>"$LOGFILE" 2>&1
    exit 0
    ;;
*"Disable Wi-Fi"*)
    nmcli r wifi off >>"$LOGFILE" 2>&1
    exit 0
    ;;
"───────────────")
    exit 0
    ;;
"Disconnect ("*)
    nmcli dev disconnect "$wifi_dev" >>"$LOGFILE" 2>&1
    exit 0
    ;;
esac

# Extract SSID safely (take everything before two spaces + a digit or before a tab)
ssid="$(printf '%s' "$choice" | sed -E 's/[[:space:]]+[0-9]+%.*$//')"

# If SSID still empty (hidden), bail
if [ -z "$ssid" ]; then
    notify-send "Wi-Fi" "Hidden SSID not supported in this simple menu"
    exit 1
fi

# If known, bring it up; else ask password and connect
if nmcli -t -f NAME connection show | grep -Fxq "$ssid"; then
    nmcli con up id "$ssid" >>"$LOGFILE" 2>&1 || notify-send "Wi-Fi" "Failed to connect: $ssid"
else
    pass="$(rofi -dmenu -password -p "Password for $ssid:" 2>>"$LOGFILE")"
    [ -z "$pass" ] && exit 0
    nmcli dev wifi connect "$ssid" password "$pass" >>"$LOGFILE" 2>&1 || notify-send "Wi-Fi" "Failed to connect: $ssid"
fi

exit 0
