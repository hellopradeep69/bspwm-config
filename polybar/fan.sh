#!/usr/bin/env bash

frames=("|" "/" "-" "\\")
i=0

while true; do
    echo "${frames[i]}"
    ((i = (i + 1) % ${#frames[@]}))
    sleep 0.2
done
