#!/usr/bin/env bash

# Frames for fan animation
# frames=("<" "-" ">")
frames=("|" "/" "-" "\\")
i=0

# Function to calculate CPU usage %
get_cpu() {
    # Read initial values
    read cpu user nice system idle iowait irq softirq steal guest </proc/stat
    prev_idle=$idle
    prev_total=$((user + nice + system + idle + iowait + irq + softirq + steal))

    sleep 0.3 # short delay

    read cpu user nice system idle iowait irq softirq steal guest </proc/stat
    total=$((user + nice + system + idle + iowait + irq + softirq + steal))

    diff_idle=$((idle - prev_idle))
    diff_total=$((total - prev_total))

    usage=$(((100 * (diff_total - diff_idle)) / diff_total))
    echo $usage
}

while true; do
    cpu=$(get_cpu)
    echo "${frames[i]} ${cpu}%"
    ((i = (i + 1) % ${#frames[@]}))
    sleep 0.1 # fan speed
done
