#!/usr/bin/env bash
# tmux-session-switcher.sh

# Detach if inside tmux
[ -n "$TMUX" ] && tmux detach

# List existing sessions with info
sessions=$(tmux list-sessions -F "#{session_name} (#{windows} windows, created: #{session_created})" 2>/dev/null)

# Add option to create a new session
sessions="${sessions}"$'\n'"[New session]"

# Use fzf to select or create
selected=$(echo "$sessions" | fzf \
    --prompt="Select or create tmux session: " \
    --height=12 \
    --border \
    --reverse \
    --bind "j:down,k:up" \
    --ansi \
    --cycle)

# Check if user wants to create a new session
if [[ "$selected" == "[New session]" ]]; then
    read -rp "Enter new session name: " session_name
    if [ -n "$session_name" ]; then
        tmux new-session -s "$session_name"
    fi
else
    # Extract session name from selection
    session_name=$(echo "$selected" | awk '{print $1}')
    if [ -n "$session_name" ]; then
        tmux attach-session -t "$session_name"
    fi
fi
