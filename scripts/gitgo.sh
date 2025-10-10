#!/usr/bin/bash

url=$(git remote get-url origin 2>/dev/null)

if [[ -z "$url" ]]; then
    echo "Not in a repo folder"
    # notify-send -u normal "Not in a repo folder"
else
    xdg-open "$url"
fi
