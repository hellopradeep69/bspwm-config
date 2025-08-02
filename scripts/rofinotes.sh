#!/bin/sh

TERMINAL="${TERMINAL:-wezterm}"     # Or foot, alacritty, etc.
EDITOR="nvim"                     # You can change this to nano, micro, etc.
NOTE_DIR="$HOME/Documents/Programming/"
DESKTOP="6"

mkdir -p "$NOTE_DIR"

launch_note() {
    local file="$1"

    # Switch to desktop 7 (bspwm specific)
    bspc desktop "$DESKTOP" -f

    # Open note in terminal
    setsid -f "$TERMINAL" -e "$EDITOR" "$file" >/dev/null 2>&1
}

new_note() {
    name=$(rofi -dmenu -p "Enter note name (with .ext)")
    [ -z "$name" ] && exit 0

    # Replace spaces with dashes
    name=$(echo "$name" | tr ' ' '-')

    # Prevent launching if it's a directory
    if [ -d "$NOTE_DIR$name" ]; then
        notify-send "❌ Invalid name: is a directory"
        exit 1
    fi

    launch_note "$NOTE_DIR$name"
}

select_note() {
    files=$(ls -1p "$NOTE_DIR" 2>/dev/null | grep -v '/')
    choice=$(printf "New\n%s" "$files" | rofi -dmenu -p "Choose note or create new")
    
    case "$choice" in
        New) new_note ;;
        "")
            exit 0
            ;;
        *)
            # Prevent opening if it's not a file
            if [ -f "$NOTE_DIR$choice" ]; then
                launch_note "$NOTE_DIR$choice"
            else
                notify-send "❌ Not a valid file: $choice"
                exit 1
            fi
            ;;
    esac
}

select_note
