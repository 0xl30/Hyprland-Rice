#!/bin/bash

factor=$(hyprctl getoption cursor:zoom_factor | awk '/float:/ {print $2}')

if [[ -z "$factor" ]]; then
  factor="1.0"
fi
if [ "$1" = "in" ]; then
  new=$(echo "scale=2; $factor * 2" | bc -l)
elif [ "$1" = "out" ]; then
  new=$(echo "scale=2; $factor / 2" | bc -l)
else
  exit 1
fi
if (( $(echo "$new < 0.1" | bc -l) )); then
  new="0.1"
elif (( $(echo "$new > 10.0" | bc -l) )); then
  new="10.0"
fi
new=$(printf "%.2f\n" "$new")

hyprctl keyword cursor:zoom_factor "$new"
