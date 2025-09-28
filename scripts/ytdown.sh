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
else
    echo "===Invalid !! Nice try==="
    echo "Try again"
    removeit
    #rm "$cache" && rm "$crop"
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
echo "=== === === === === === === === === === === === ==="
read -r option

if [[ "$option" != "B" ]]; then
    echo "~~~~custom menu soon~~~~"
    echo "for now use Best"
else
    echo " "
    echo "=== === === === === === === === === === === === ==="
    echo "1.ONLY AUDIO(type 1)"
    echo "2.ONLY VIDEO & AUDIO(type 2)"
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
