#!/usr/bin/env bash
# Tmux Session Switcher with human-readable creation time and fzf

# List all sessions with name, number of windows, and creation time
sessions=$(tmux list-sessions -F "#{session_name} #{windows} #{session_created}")

# Format sessions for display
formatted_sessions=$(echo "$sessions" | awk '{
    # Convert epoch to human-readable date
    cmd = "date -d @" $3 " \"+%a %b %d %H:%M:%S %Y\""
    cmd | getline created
    close(cmd)

    # Print number, windows, and creation date
    printf "%s: %s window%s (created %s)\n", NR-1, $2, ($2>1?"s":""), created
}')

# Let user pick a session with fzf
selected=$(
    echo "$formatted_sessions" | fzf \
        --prompt="Select tmux session > " \
        --bind "j:down,k:up,ctrl-d:half-page-down,ctrl-u:half-page-up" \
        --height=40% --border --ansi \
        --color "prompt:green,fg+:yellow,info:cyan"
)

# If a session was selected
if [[ -n "$selected" ]]; then
    number=$(echo "$selected" | awk -F': ' '{print $1}')
    session_name=$(echo "$sessions" | sed -n "$((number + 1))p" | awk '{print $1}')

    if [[ -n "$TMUX" ]]; then
        tmux switch-client -t "$session_name"
    else
        tmux attach-session -t "$session_name"
    fi

    notify-send "Tmux Session Switched" "$selected"
fi
