#!/bin/bash

# removes month directories from sections (e.g. /glftpd/site/section1/2024/10/) if less than X% (default: 5) are free on the device

min_free_space_percent=5
check_dir="/glftpd/site"
directories_to_check=("section1" "section2" "section3")

# do not change anything below this comment

function free_percent {
    used_percent=$(df "$check_dir" | tail -1 | awk '{print $5}' | sed 's/%//')
    free_percent=$((100 - used_percent))
    echo $free_percent
}

function add_zero {
    if [ $1 -lt 10 ]; then
        echo "0$1"
    else
        echo "$1"
    fi
}

current_year=$(date +%Y)
previous_year=$((current_year - 1))

for year in $(seq $previous_year $current_year); do
    for month in $(seq 1 12); do
        if [ $(free_percent) -lt $min_free_space_percent ]; then
            for section in "${directories_to_check[@]}"; do
                folder="$check_dir/$section/$year/$(add_zero $month)"
                if [ -d "$folder" ]; then
                    echo "rm -rf $folder"
                    rm -rf "$folder"
                fi
            done
        fi
    done
done
