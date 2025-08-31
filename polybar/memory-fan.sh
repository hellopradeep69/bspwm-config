#!/usr/bin/env bash

frames=("|" "/" "-" "\\")
i=0

while true; do
    # Get memory used in MB
    mem_used=$(free -m | awk '/^Mem:/ {print $3}')
    # Print spinner + memory
    echo "${frames[i]} ${mem_used}MB"
    # Next frame
    ((i = (i + 1) % ${#frames[@]}))
    sleep 0.5
done
