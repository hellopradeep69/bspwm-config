#!/usr/bin/env bash
# tmux-fzf-dashboard.sh
# Tmux session/window selector with FZF (supports session templates, j/k navigation, dd to delete)

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
    echo "$name (${line#* } created: $date_str)"
}

session_exists() {
    tmux has-session -t "$1" 2>/dev/null
}

create_template_session() {
    local session_name="$1"
    local template="$2"

    case "$template" in
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
        tmux new-window -t "$session_name" -n "xtra"
        tmux new-window -t "$session_name" -n "btop"
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

# Add only the new session option; deletion handled by dd keybinding
sessions+=$'\n'"[New session]"

# -------------------------------
# SELECT SESSION
# -------------------------------

selected_session=$(echo -e "$sessions" | fzf \
    --prompt="Select tmux session (j/k to navigate, x to delete): " \
    --height=15 \
    --border \
    --reverse \
    --bind "j:down,k:up,x:execute-silent(
        tmux kill-session -t \"$(echo {} | awk '{print $1}')\" &&
    )+reload(tmux list-sessions -F \"#{session_name} (#{windows} windows, created: #{session_created})\")" \
    --preview 'tmux list-windows -t {1} -F "#{window_index}: #{window_name} | #{pane_current_command}"' \
    --cycle)

# Abort if nothing selected
[ -z "$selected_session" ] && exit 0

# -------------------------------
# HANDLE NEW SESSION
# -------------------------------
if [[ "$selected_session" == "[New session]" ]]; then
    read -rp "Enter new session name: " session_name
    [ -z "$session_name" ] && exit 0

    # Template selection with preview
    template=$(printf "default\ndev\nweb\nsuma" | fzf \
        --prompt="Select session template: " \
        --height=15 \
        --border \
        --reverse \
        --bind "j:down,k:up,q:abort" \
        --cycle \
        --preview '
            case {} in
                default)
                    echo "Template: default"
                    echo "Windows:"
                    echo "  - main"
                    ;;
                dev)
                    echo "Template: dev"
                    echo "Windows:"
                    echo "  - editor"
                    echo "  - server"
                    echo "  - logs"
                    ;;
                web)
                    echo "Template: web"
                    echo "Windows:"
                    echo "  - frontend"
                    echo "  - backend"
                    echo "  - database"
                    ;;
                suma)
                    echo "Template: suma"
                    echo "Windows:"
                    echo "  - nvim"
                    echo "  - xtra"
                    echo "  - btop"
                    ;;
            esac
        ')

    [ -z "$template" ] && template="default"

    # Create session with selected template
    create_template_session "$session_name" "$template"

    # Attach immediately
    tmux attach-session -t "$session_name"
    exit 0
fi

# -------------------------------
# STRIP ANSI AND EXTRACT SESSION NAME
# -------------------------------
session_name=$(echo "$selected_session" | sed 's/\x1b\[[0-9;]*m//g' | awk '{print $1}')

# -------------------------------
# SELECT WINDOW
# -------------------------------
windows=$(tmux list-windows -t "$session_name" -F "#{window_index}: #{window_name}")
if [ -z "$windows" ]; then
    echo "No windows in session $session_name. Creating one..."
    tmux new-window -t "$session_name" -n "main"
    windows=$(tmux list-windows -t "$session_name" -F "#{window_index}: #{window_name}")
fi

selected_window=$(echo "$windows" | fzf \
    --prompt="Select window (q to quit): " \
    --height=12 \
    --border \
    --reverse \
    --bind "j:down,k:up,q:abort")

# Abort if nothing selected
[ -z "$selected_window" ] && exit 0

window_index=$(echo "$selected_window" | cut -d':' -f1)

# -------------------------------
# ATTACH TO SELECTED SESSION/WINDOW
# -------------------------------
tmux attach-session -t "$session_name" \; select-window -t "$window_index"
