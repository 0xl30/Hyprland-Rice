#!/bin/bash
set -euo pipefail

# Kill rofi if running
pgrep -x "rofi" >/dev/null && pkill rofi

# Get resolution and scale
x_mon=$(hyprctl -j monitors | jq -r '.[] | select(.focused==true) | .width')
y_mon=$(hyprctl -j monitors | jq -r '.[] | select(.focused==true) | .height')
scale=$(hyprctl -j monitors | jq -r '.[] | select(.focused==true) | .scale')

# Calculate effective dimensions
width=$(echo "$x_mon * $scale" | bc)
height=$(echo "$y_mon * $scale" | bc)

# Percentages
percentage_width=40
percentage_height=95

# Calculate dynamic sizes
dynamic_width=$(echo "$width * $percentage_width / 100" | bc)
dynamic_height=$(echo "$height * $percentage_height / 100" | bc)

# Cap max dimensions
max_width=1200
max_height=1000

if [ "$dynamic_width" -gt "$max_width" ]; then
  dynamic_width=$max_width
fi
if [ "$dynamic_height" -gt "$max_height" ]; then
  dynamic_height=$max_height
fi

# Launch YAD
uri_path="$HOME/.config/yad/index.html"
[ -f "$uri_path" ] || { echo "HTML file not found at $uri_path"; exit 1; }

yad --html --uri="file:$uri_path" \
  --width="$dynamic_width" --height="$dynamic_height"
