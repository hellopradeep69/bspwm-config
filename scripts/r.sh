#!/bin/bash

mode="$1"

normal_mode() {
    rofi -show drun \
        -kb-row-up "k" \
        -kb-row-down "j" \
        -kb-row-first "g" \
        -kb-row-last "G" \
        -kb-accept-entry "l,Return" \
        -kb-cancel "q,h,Escape" \
        -kb-custom-1 "i"
}

insert_mode() {
    rofi -show drun \
        -kb-cancel "Escape" \
        -kb-custom-1 "Escape"
}

if [[ "$mode" == "insert" ]]; then
    insert_mode
    case $? in
    10) # Custom key 1 (Escape)
        exec "$0" normal
        ;;
    esac
else
    normal_mode
    case $? in
    10) # Custom key 1 (i)
        exec "$0" insert
        ;;
    esac
fi
