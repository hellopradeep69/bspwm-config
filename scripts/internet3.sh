#!/bin/bash

# Set your rofi theme file here
ROFI_THEME="$HOME/.config/rofi/themes/spot.rasi"
ROFI_THEME2="$HOME/.config/rofi/themes/demnu.rasi"

# Rofi options
ROFI_OPTS="-theme $ROFI_THEME -matching fuzzy -i"
ROFI_OPTS2="-theme $ROFI_THEME2 -matching fuzzy -i"

# Prompt user to enter prefixed query
input=$(rofi -dmenu $ROFI_OPTS -p "Search (c:, r:, d:, y:, w:, g:, b:)")

# Exit if empty
[ -z "$input" ] && exit 1

# Extract prefix and query
prefix="${input%%:*}"
query="${input#*:}"

# Trim whitespace
query=$(echo "$query" | xargs)

# Determine URL based on prefix
url=$(case "$prefix" in
    c) echo "$query = $(echo "$query" | bc -l)" | rofi -dmenu $ROFI_OPTS2 -p "Result:" >/dev/null ;;
    r) echo "https://reddit.com/r/$query" ;;
    d) echo "https://duckduckgo.com/?q=$query" ;;
    b) echo "https://search.brave.com/search?q=$query" ;;
    w) echo "https://en.wikipedia.org/wiki/$query" ;;
    y) echo "https://www.youtube.com/results?search_query=$query" ;;
    g) echo "https://github.com/search?q=$query" ;;
    *) notify-send "Unknown prefix '$prefix'" && exit 1 ;;
    esac)

# Open in default browser
xdg-open "$url"
