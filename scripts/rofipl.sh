#!/bin/bash

THEME="demnu2"
MUSIC_DIR="$HOME/Music"
SOCKET="/tmp/mpv-local.sock"

# Ensure music directory exists
cd "$MUSIC_DIR" || exit 1

# Prompt for action mode
mode=$(printf "🎵 Play\n➕ Enqueue\n➖ Dequeue\n📜 View Playlist\n🎛️ Controls" \
    | rofi -dmenu -matching fuzzy -i -theme "$THEME" -p "Select Mode : ")
[ -z "$mode" ] && exit

# Helper: select songs
select_tracks() {
    find . -type f \( -iname "*.mp3" -o -iname "*.flac" -o -iname "*.wav" -o -iname "*.m4a" \) \
        | sed 's|^\./||' \
        | rofi -dmenu -matching fuzzy -i -theme "$THEME" -multi-select -p "🎧 Select Songs"
}

# Convert selected text into array
read_selection_into_array() {
    IFS=$'\n' read -d '' -r -a playlist <<< "$1"
}

# Ensure socket is ready
wait_for_socket() {
    for i in {1..10}; do
        [ -S "$SOCKET" ] && return
        sleep 0.2
    done
    notify-send "MPV socket not available"
    exit 1
}

# Handle each mode
case "$mode" in
    "🎵 Play")
        rm -f "$SOCKET"
        selected=$(select_tracks)
        [ -z "$selected" ] && exit
        read_selection_into_array "$selected"
        mpv --no-video --input-ipc-server="$SOCKET" --quiet "${playlist[@]}" &
        wait_for_socket
        ;;

    "➕ Enqueue")
        [ ! -S "$SOCKET" ] && notify-send "MPV is not running" && exit
        selected=$(select_tracks)
        [ -z "$selected" ] && exit
        read_selection_into_array "$selected"
        for track in "${playlist[@]}"; do
            echo '{ "command": ["loadfile", "'"$MUSIC_DIR/$track"'", "append-play"] }' | socat - "$SOCKET"
        done
        ;;

    "➖ Dequeue")
        [ ! -S "$SOCKET" ] && notify-send "MPV is not running" && exit
        echo '{ "command": ["playlist-remove", 0] }' | socat - "$SOCKET"
        ;;

    "📜 View Playlist")
        [ ! -S "$SOCKET" ] && notify-send "MPV is not running" && exit
        echo '{ "command": ["get_property", "playlist"] }' | socat - "$SOCKET" \
        | jq -r --arg dir "$MUSIC_DIR/" '
            .data[] |
            (if .current == true then "▶️" else "  " end) + " " + (.filename | sub($dir; ""))' \
        | rofi -dmenu -matching fuzzy -i -theme "$THEME" -p "🎶 Playlist (▶️ = current) : " || true
        ;;

    "🎛️ Controls")
        [ ! -S "$SOCKET" ] && notify-send "MPV is not running" && exit
        while true; do
            action=$(printf "⏸️ Pause/Resume\n⏭️ Next\n⏮️ Prev\n⏪ Back 10s\n⏩ Forward 10s\n🔁 Toggle Loop\n⏹️ Quit" \
                | rofi -dmenu -matching fuzzy -i -theme "$THEME" -p "🎵 Controls : ")

            case "$action" in
                "⏸️ Pause/Resume") echo '{ "command": ["cycle", "pause"] }' | socat - "$SOCKET" ;;
                "⏭️ Next") echo '{ "command": ["playlist-next"] }' | socat - "$SOCKET" ;;
                "⏮️ Prev") echo '{ "command": ["playlist-prev"] }' | socat - "$SOCKET" ;;
                "⏪ Back 10s") echo '{ "command": ["seek", -10, "relative"] }' | socat - "$SOCKET" ;;
                "⏩ Forward 10s") echo '{ "command": ["seek", 10, "relative"] }' | socat - "$SOCKET" ;;
                "🔁 Toggle Loop") echo '{ "command": ["cycle", "loop-playlist"] }' | socat - "$SOCKET" ;;
                "⏹️ Quit") echo '{ "command": ["quit"] }' | socat - "$SOCKET" ; break ;;
                "") break ;;
            esac
        done
        ;;
esac
