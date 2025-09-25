#!/bin/bash

# Get the start path of the current tmux pane
pane_path=$(tmux display-message -p "#{pane_start_path}")
cd "$pane_path" || {
    echo "Failed to cd into pane path"
    exit 1
}

# Get the Git remote URL
url=$(git remote get-url origin 2>/dev/null)

# Check if URL exists and open it
if [[ -n "$url" ]]; then
    # Use xdg-open on Linux, open on macOS
    if command -v xdg-open >/dev/null 2>&1; then
        xdg-open "$url"
    elif command -v open >/dev/null 2>&1; then
        open "$url"
    else
        echo "No command to open URLs found. URL is: $url"
    fi
else
    echo "No remote found"
fi
