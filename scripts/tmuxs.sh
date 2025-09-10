#!/usr/bin/env bash
# tmux-fzf-dashboard.sh
# Tmux session/window selector with FZF (supports session templates, j/k navigation, and enhanced UX)

# Detach if inside tmux
[ -n "$TMUX" ] && tmux detach

# -------------------------------
# FUNCTIONS
# -------------------------------

list_sessions() {
    tmux list-sessions -F "#{session_name} (#{windows} windows, created: #{session_created})" 2>/dev/null
}

format_session() {
    local line="$1"
    local name ts date_str
    name=$(echo "$line" | awk '{print $1}')
    ts=$(echo "$line" | grep -oP '\d{10}')
    date_str=$(date -d @"$ts" '+%b %d %Y %H:%M')
    echo "$name (created: $date_str)"
}

session_exists() {
    tmux has-session -t "$1" 2>/dev/null
}

create_template_session() {
    local session_name="$1"
    local template="$2"

    case "$template" in
    project)
        tmux new-session -d -s "$session_name" -n "project" -c "$HOME/Project/"
        tmux new-window -t "$session_name" -n "html" -c "$HOME/Project/html/"
        tmux new-window -t "$session_name" -n "logs"
        ;;
    dev)
        tmux new-session -d -s "$session_name" -n "editor"
        tmux new-window -t "$session_name" -n "server"
        tmux new-window -t "$session_name" -n "logs"
        ;;
    web)
        tmux new-session -d -s "$session_name" -n "frontend"
        tmux new-window -t "$session_name" -n "backend"
        tmux new-window -t "$session_name" -n "database"
        ;;
    suma)
        tmux new-session -d -s "$session_name" -n "nvim"
        tmux split-window -h -t "$session_name:1" -c "#{pane_current_path}"
        tmux resize-pane -t "$session_name:1.0" -Z
        tmux new-window -t "$session_name" -n "xtra"
        tmux new-window -t "$session_name" -n "btop"
        tmux select-window -t "$session_name:1"
        ;;
    *)
        tmux new-session -d -s "$session_name" -n "main"
        ;;
    esac
}

# -------------------------------
# BUILD SESSION LIST
# -------------------------------
sessions=""
existing=$(list_sessions)
if [ -n "$existing" ]; then
    while read -r line; do
        sessions+=$(format_session "$line")$'\n'
    done <<<"$existing"
fi
sessions+=$'\n'"[New session]"$'\n'"[Delete session]"

# -------------------------------
# SELECT SESSION
# -------------------------------
selected_session=$(echo -e "$sessions" | fzf \
    --prompt="Select tmux session (q to quit): " \
    --height=15 \
    --border \
    --reverse \
    --bind "j:down,k:up,q:abort" \
    --preview 'tmux list-windows -t {1} -F "#{window_index}: #{window_name} | #{pane_current_command}"' \
    --cycle)

[ -z "$selected_session" ] && exit 0

# -------------------------------
# HANDLE NEW SESSION
# -------------------------------
if [[ "$selected_session" == "[New session]" ]]; then
    read -rp "Enter new session name: " session_name
    [ -z "$session_name" ] && exit 0

    template=$(printf "suma\nproject\ndev\nweb\ndefault" | fzf \
        --prompt="Select session template: " \
        --height=15 \
        --border \
        --bind "j:down,k:up,q:abort" \
        --cycle \
        --reverse)
    [ -z "$template" ] && template="default"

    create_template_session "$session_name" "$template"
    tmux attach-session -t "$session_name"
    exit 0
fi

# -------------------------------
# HANDLE DELETE SESSION
# -------------------------------
if [[ "$selected_session" == "[Delete session]" ]]; then
    while true; do
        del_session=$(tmux list-sessions -F "#{session_name} (#{windows} windows, created: #{session_created})" |
            fzf --prompt="Select session to delete (q to quit): " \
                --height=12 --border --reverse --bind "j:down,k:up,q:abort")
        [ -z "$del_session" ] && break

        del_session_name=$(echo "$del_session" | awk '{print $1}')
        read -rp "Confirm deletion of '$del_session_name'? [y/N]: " confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            tmux kill-session -t "$del_session_name"
            echo "Deleted session: $del_session_name"
        else
            echo "Aborted deletion."
        fi
    done
    exit 0
fi

# -------------------------------
# SELECT WINDOW
# -------------------------------
session_name=$(echo "$selected_session" | sed 's/\x1b\[[0-9;]*m//g' | awk '{print $1}')
windows=$(tmux list-windows -t "$session_name" -F "#{window_index}: #{window_name}")
[ -z "$windows" ] && tmux new-window -t "$session_name" -n "main" && windows=$(tmux list-windows -t "$session_name" -F "#{window_index}: #{window_name}")

selected_window=$(echo "$windows" | fzf \
    --prompt="Select window (q to quit): " \
    --height=12 \
    --border \
    --reverse \
    --bind "j:down,k:up,q:abort")
[ -z "$selected_window" ] && exit 0

window_index=$(echo "$selected_window" | cut -d':' -f1)

# -------------------------------
# ATTACH TO SELECTED SESSION & WINDOW
# -------------------------------
tmux attach-session -t "$session_name" \; select-window -t "$window_index"
