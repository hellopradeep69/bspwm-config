#!/usr/bin/bash
cache="$HOME/.tdown.txt"
crop="$HOME/.crop.txt"
touch "$cache" "$crop"

# functon that remove temp file
removeit() {
    rm "$cache" && rm "$crop"
}

echo "-----------------YTDOWN-----------------"
echo "Enter a url to download : "
read -r url
# echo "$url" >>$HOME/.tdown.txt
echo "$url" >>"$cache"

# it collect first 17 char and write down in a file
head -c 17 "$cache" >>"$crop"
read -r check <"$crop"
# echo "$check"
# cat "$cache"
# cat "$crop"

# check if the url is valid
if [[ "$check" == "https://youtu.be/" ]]; then
    echo "===Healthy url nice==="
elif [[ "$check" == "https://youtube.c" ]]; then
    echo "=== === === === === === === === === === === === ==="
    echo "Playlist Detected"
    echo "Only Audio format will be Downloaded"
    echo "=== === === === === === === === === === === === ==="
    yt-dlp -x --audio-format m4a "$url"
    removeit
    exit 0
else
    echo "===Invalid !! Nice try==="
    echo "Try again"
    removeit
    exit 0
fi

# yt dlp format check the url
yt-dlp -F "$url"

echo "Take a moment and glaze at avail option "
echo " "
echo "do you want best or custom :"
echo "=== === === === === === === === === === === === ==="
echo "[B]:Best(type B)"
echo "[C]:Custom(type C){SOON! select B for now}"
echo "[Q]:Quit(type Q)"
echo "=== === === === === === === === === === === === ==="
read -r option

if [[ "$option" = "C" ]]; then
    echo "~~~~custom menu soon~~~~"
    echo "select audio output from above info (eg:140)"
    read -r Audio
    echo "select video output from above info (eg:136)"
    read -r Video
    echo "downloading in format Audio:"$Audio" and Video:"$Video" "
    yt-dlp -f "$Audio"+"$Video" "$url"
elif [[ "$option" = "Q" ]]; then
    echo "Quit"
    removeit
    exit 0
else
    echo " "
    echo "=== === === === === === === === === === === === ==="
    echo "1.ONLY AUDIO(type 1.)"
    echo "2.ONLY VIDEO & AUDIO(type 2.)"
    echo "=== === === === === === === === === === === === ==="
    read -r submenu
    if [[ "$submenu" != "2" ]]; then
        echo " "
        echo "=== === === === === === === === === === === === ==="
        echo "ONLY AUDIO"
        echo "=== === === === === === === === === === === === ==="
        yt-dlp -f bestaudio --extract-audio --audio-format mp3 --audio-quality 192k "$url"
    else
        echo " "
        echo "=== === === === === === === === === === === === ==="
        echo "VIDEO & AUDIO"
        echo "=== === === === === === === === === === === === ==="
        echo "Download...."
        echo "High quality"
        yt-dlp -f best "$url"
        removeit
        #rm "$cache" && rm "$crop"
        exit 0
    fi
fi

removeit
