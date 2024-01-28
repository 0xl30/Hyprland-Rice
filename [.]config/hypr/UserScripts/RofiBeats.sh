#!/bin/bash

# Directory for icons
iDIR="$HOME/.config/swaync/icons"

# Note: You can add more options below with the following format:
# ["TITLE"]="link"

# Define menu options as an associative array
declare -A menu_options=(
  ["ʙᴀɴɢʟᴀ ʟᴏꜰɪ 📻🎶"]="https://www.youtube.com/playlist?list=PL5mldcWb5ccAYadba77QslD8ZwpznDXrm"
  ["ʜɪɴᴅɪ ʟᴏꜰɪ 📻🎶"]="https://www.youtube.com/playlist?list=PL5mldcWb5ccCoMeoTEwJGC9V9ax-z89wu"
  ["ᴀʀᴀʙɪᴄ ʀᴇᴍɪx 🎻🎶"]="https://www.youtube.com/playlist?list=PL5mldcWb5ccAq_dVvoVSQlxxdLAzS4pen"
  ["ᴊᴀᴘᴀɴᴇꜱᴇ ʀᴇᴍɪx ☯️☕️🎶"]="https://www.youtube.com/playlist?list=PL5mldcWb5ccDjEPvcDvKkpMc24NXRSNo1"
  ["ɪɴᴅᴏɴᴇꜱɪᴀɴ ʀᴇᴍɪx 👽🎶"]="https://www.youtube.com/playlist?list=PL5mldcWb5ccCqwe9CAxdoI6DUCnQkCZ4u"
  ["ᴘᴜʀᴜʟɪᴀ ᴅᴊ 🔊🎶"]="https://www.youtube.com/playlist?list=PL5mldcWb5ccB_Y2B2nrWGsBoZ5NtS7_OL"
  ["ʜɪɴᴅɪ ᴅᴊ 🔊🎶"]="https://www.youtube.com/playlist?list=PL5mldcWb5ccDe5hhI8FU9UPgJhbjKO4lR"
  ["ʜɪɴᴅᴜɪꜱᴍ 🚩"]="https://www.youtube.com/playlist?list=PL5mldcWb5ccDmgAFjv__crdqSDx0TYbd7"
)

# Function for displaying notifications
notification() {
  notify-send -u normal -i "$iDIR/music.png" "Playing now: $@"
}

# Main function
main() {
  choice=$(printf "%s\n" "${!menu_options[@]}" | rofi -dmenu -config ~/.config/rofi/config-rofi-Beats.rasi -i -p "")

  if [ -z "$choice" ]; then
    exit 1
  fi

  link="${menu_options[$choice]}"

  notification "$choice"
  
  # Check if the link is a playlist
  if [[ $link == *playlist* ]]; then
    mpv --shuffle --vid=no "$link"
  else
    mpv "$link"
  fi
}

# Check if an online music process is running and send a notification, otherwise run the main function
pkill -f http && notify-send -u low -i "$iDIR/music.png" "Online Music stopped" || main
