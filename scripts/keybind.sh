#!/usr/bin/bash

key_set() {
    setxkbmap -option ctrl:nocaps
    xmodmap -e "keycode 108 = Escape"
}

key_set
