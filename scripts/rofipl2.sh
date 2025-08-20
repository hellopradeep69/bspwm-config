#!/bin/bash

THEME="demnu2"
MUSIC_DIR="$HOME/Music"
SOCKET="/tmp/mpv-local.sock"
PLAYLIST_DIR="$HOME/Music/playlists"

mkdir -p "$PLAYLIST_DIR"
cd "$MUSIC_DIR" || exit 1

# --- Helper Functions ---
select_tracks() {
    find . -type f \( -iname "*.mp3" -o -iname "*.flac" -o -iname "*.wav" -o -iname "*.m4a" \) |
        sed 's|^\./||' |
        rofi -dmenu -matching fuzzy -i -theme "$THEME" -multi-select -p "🎧 Select Songs"
}

read_selection_into_array() {
    IFS=$'\n' read -d '' -r -a playlist <<<"$1"
}

wait_for_socket() {
    for i in {1..10}; do
        [ -S "$SOCKET" ] && return
        sleep 0.2
    done
    notify-send "MPV socket not available"
    exit 1
}

# --- Playlist Functions ---
save_playlist() {
    [ ! -S "$SOCKET" ] && notify-send "MPV is not running" && return
    pl=$(echo '{ "command": ["get_property", "playlist"] }' | socat - "$SOCKET")
    name=$(rofi -dmenu -theme "$THEME" -p "💾 Save Playlist As:")
    [ -z "$name" ] && return
    echo "$pl" | jq -r '.data[].filename' >"$PLAYLIST_DIR/$name.m3u"
    notify-send "Playlist saved as $name"
}

load_playlist() {
    selected=$(find "$PLAYLIST_DIR" -type f -name "*.m3u" |
        xargs -I{} basename "{}" .m3u |
        rofi -dmenu -theme "$THEME" -p "📂 Load Playlist:")
    [ -z "$selected" ] && return
    mapfile -t playlist <"$PLAYLIST_DIR/$selected.m3u"
    rm -f "$SOCKET"
    mpv --no-video --input-ipc-server="$SOCKET" --quiet "${playlist[@]}" &
    wait_for_socket
}

append_to_playlist() {
    selected_playlist=$(find "$PLAYLIST_DIR" -type f -name "*.m3u" |
        xargs -I{} basename "{}" .m3u |
        rofi -dmenu -theme "$THEME" -p "📋 Choose Playlist to Append:")
    [ -z "$selected_playlist" ] && return

    selected_tracks=$(select_tracks)
    [ -z "$selected_tracks" ] && return

    echo "$selected_tracks" >>"$PLAYLIST_DIR/$selected_playlist.m3u"
    notify-send "Tracks appended to $selected_playlist"
}

playlist_menu() {
    choice=$(printf "💾 Save Playlist\n📂 Load Playlist\n📋 Append to Playlist" |
        rofi -dmenu -theme "$THEME" -p "🎼 Playlist Menu:")
    case "$choice" in
    "💾 Save Playlist") save_playlist ;;
    "📂 Load Playlist") load_playlist ;;
    "📋 Append to Playlist") append_to_playlist ;;
    esac
}

# --- Queue Functions ---
view_queue() {
    [ ! -S "$SOCKET" ] && notify-send "MPV is not running" && return
    echo '{ "command": ["get_property", "playlist"] }' | socat - "$SOCKET" |
        jq -r --arg dir "$MUSIC_DIR/" '
            .data[] |
            (if .current == true then "▶️" else "  " end) + " " + (.filename | sub($dir; ""))' |
        rofi -dmenu -matching fuzzy -i -theme "$THEME" -p "🎶 Queue (▶️ = current):" || true
}

enqueue() {
    [ ! -S "$SOCKET" ] && notify-send "MPV is not running" && return
    selected=$(select_tracks)
    [ -z "$selected" ] && return
    read_selection_into_array "$selected"
    for track in "${playlist[@]}"; do
        echo '{ "command": ["loadfile", "'"$MUSIC_DIR/$track"'", "append-play"] }' | socat - "$SOCKET"
    done
}

dequeue() {
    [ ! -S "$SOCKET" ] && notify-send "MPV is not running" && return
    echo '{ "command": ["playlist-remove", 0] }' | socat - "$SOCKET"
}

queue_menu() {
    choice=$(printf "📜 View Queue\n➕ Enqueue\n➖ Dequeue" |
        rofi -dmenu -theme "$THEME" -p "📜 Queue Menu:")
    case "$choice" in
    "📜 View Queue") view_queue ;;
    "➕ Enqueue") enqueue ;;
    "➖ Dequeue") dequeue ;;
    esac
}

# --- Playback Controls ---
controls_menu() {
    [ ! -S "$SOCKET" ] && notify-send "MPV is not running" && exit
    while true; do
        action=$(printf "⏸️ Pause/Resume\n⏭️ Next\n⏮️ Prev\n⏪ Back 10s\n⏩ Forward 10s\n🔁 Toggle Loop\n⏹️ Quit" |
            rofi -dmenu -matching fuzzy -i -theme "$THEME" -p "🎛️ Controls:")
        case "$action" in
        "⏸️ Pause/Resume") echo '{ "command": ["cycle", "pause"] }' | socat - "$SOCKET" ;;
        "⏭️ Next") echo '{ "command": ["playlist-next"] }' | socat - "$SOCKET" ;;
        "⏮️ Prev") echo '{ "command": ["playlist-prev"] }' | socat - "$SOCKET" ;;
        "⏪ Back 10s") echo '{ "command": ["seek", -10, "relative"] }' | socat - "$SOCKET" ;;
        "⏩ Forward 10s") echo '{ "command": ["seek", 10, "relative"] }' | socat - "$SOCKET" ;;
        "🔁 Toggle Loop") echo '{ "command": ["cycle", "loop-playlist"] }' | socat - "$SOCKET" ;;
        "⏹️ Quit")
            echo '{ "command": ["quit"] }' | socat - "$SOCKET"
            break
            ;;
        "") break ;;
        esac
    done
}

# --- Main Menu ---
main_menu=$(printf "🎵 Play\n📜 Queue\n📂 Playlist\n🎛️ Controls" |
    rofi -dmenu -matching fuzzy -i -theme "$THEME" -p "🎶 Select Mode:")
[ -z "$main_menu" ] && exit

case "$main_menu" in
"🎵 Play")
    rm -f "$SOCKET"
    selected=$(select_tracks)
    [ -z "$selected" ] && exit
    read_selection_into_array "$selected"
    mpv --no-video --input-ipc-server="$SOCKET" --quiet "${playlist[@]}" &
    wait_for_socket
    ;;
"📜 Queue") queue_menu ;;
"📂 Playlist") playlist_menu ;;
"🎛️ Controls") controls_menu ;;
esac
