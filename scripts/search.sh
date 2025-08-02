#!/bin/bash

# Step 1: Show Rofi Menu
choice=$(printf "📁 Search Files\n❌ Cancel" | rofi -dmenu -p "File Tools")

# Exit if user cancels
[ -z "$choice" ] && exit

# Step 2: If user selects "Search Files"
if [ "$choice" = "📁 Search Files" ]; then
    # Run fzf for fuzzy search
    selected=$(find ~ -type f -o -type d 2>/dev/null | fzf --prompt="🔍 Search > " --height=40% --border)

    # Exit if nothing selected
    [ -z "$selected" ] && exit

    # Open the folder containing the selected file
    xdg-open "$(dirname "$selected")"
fi
