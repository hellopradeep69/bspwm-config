#!/bin/bash

bspc subscribe node_flag | while read -r _ _ _ flag value; do
    if [[ "$flag" == "fullscreen" ]]; then
        if [[ "$value" == "on" ]]; then
            polybar-msg -b colorblocks cmd hide
        else
            polybar-msg -b colorblocks cmd show
        fi
    fi
done
