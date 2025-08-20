#!/usr/bin/env bash
# tmux-session-switcher-rofi.sh

# Set your rofi theme file path (custom theme)
ROFI_THEME="$HOME/.config/rofi/themes/side.rasi"

# Detach if inside tmux
[ -n "$TMUX" ] && tmux detach

# List existing sessions with info
sessions=$(tmux list-sessions -F "#{session_name} (#{windows} windows, created: #{session_created})" 2>/dev/null)

# Convert session_created to human-readable
sessions=$(echo "$sessions" | while read -r line; do
    name=$(echo "$line" | awk '{print $1}')
    ts=$(echo "$line" | grep -oP '\d{10}')
    if [ -n "$ts" ]; then
        date_str=$(date -d @"$ts" '+%b %d %Y %H:%M')
        echo "$name (${line#* } created: $date_str)"
    else
        echo "$line"
    fi
done)

# Add extra options
sessions="${sessions}"$'\n'"[New session]"$'\n'"[Delete session]"

# Use rofi instead of fzf
selected=$(echo "$sessions" | rofi -dmenu \
    -p "Select tmux action:" \
    -theme "$ROFI_THEME" \
    -i)

# Handle new session
if [[ "$selected" == "[New session]" ]]; then
    session_name=$(rofi -dmenu -p "Enter new session name:" -theme "$ROFI_THEME")
    if [ -n "$session_name" ]; then
        tmux new-session -ds "$session_name"
        notify-send "Tmux Session" "New session '$session_name' created."
        tmux attach -t "$session_name"
    fi

# Handle delete session
elif [[ "$selected" == "[Delete session]" ]]; then
    del_session=$(tmux list-sessions -F "#{session_name}" | rofi -dmenu \
        -p "Select session to delete:" \
        -theme "$ROFI_THEME" \
        -i)
    if [ -n "$del_session" ]; then
        confirm=$(echo -e "No\nYes" | rofi -dmenu -p "Delete '$del_session'?" -theme "$ROFI_THEME")
        if [[ "$confirm" == "Yes" ]]; then
            tmux kill-session -t "$del_session"
            notify-send "Tmux Session" "Session '$del_session' deleted."
        else
            notify-send "Tmux Session" "Deletion of '$del_session' cancelled."
        fi
    fi

# Handle attach existing session
elif [ -n "$selected" ]; then
    session_name=$(echo "$selected" | awk '{print $1}')
    if [ -n "$session_name" ]; then
        if [ -n "$TMUX" ]; then
            tmux switch-client -t "$session_name"
        else
            tmux attach-session -t "$session_name"
        fi
        notify-send "Tmux Session" "Attached to '$session_name'."
    fi
fi
