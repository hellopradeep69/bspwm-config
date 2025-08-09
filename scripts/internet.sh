#!/bin/bash

# Set your rofi theme file here
ROFI_THEME="$HOME/.config/rofi/themes/spot.rasi"
ROFI_THEME2="$HOME/.config/rofi/themes/demnu.rasi"

# Rofi options
ROFI_OPTS="-theme $ROFI_THEME -matching fuzzy -i"
ROFI_OPTS2="-theme $ROFI_THEME2 -matching fuzzy -i"

# Prompt user to enter prefixed query like: c 5+5 or d chatgpt
input=$(rofi -dmenu $ROFI_OPTS -p "Search (c, r, d, y, w, g, b)")

# Exit if empty
[ -z "$input" ] && exit 1

# Extract prefix (first word) and query (rest)
prefix=$(echo "$input" | awk '{print $1}')
query=$(echo "$input" | cut -d' ' -f2-)

# Trim whitespace
query=$(echo "$query" | xargs)

# Determine URL or action based on prefix
case "$prefix" in
# c)
#     result=$(echo "$query" | bc -l)
#     echo "$query = $result" | rofi -dmenu $ROFI_OPTS2 -p "Result:" >/dev/null
#     exit
#     ;;
c) url="https://chat.openai.com/?q=$query" ;;
r) url="https://reddit.com/r/$query" ;;
d) url="https://duckduckgo.com/?q=$query" ;;
b) url="https://search.brave.com/search?q=$query" ;;
w) url="https://en.wikipedia.org/wiki/$query" ;;
y) url="https://www.youtube.com/results?search_query=$query" ;;
g) url="https://github.com/search?q=$query" ;;
*) notify-send "Unknown prefix '$prefix'" && exit 1 ;;
esac

# Open in browser
xdg-open "$url"
