#!/bin/bash
############This Is 0xRyan Playlists############

# Directory local music folder
mDIR="$HOME/Music/"

# Directory for icons
iDIR="$HOME/.config/swaync/icons"

# Online Stations. Edit as required
declare -A online_music=(
  ["ʀᴀᴅɪᴏ ᴍɪʀᴄʜɪ 98.3 📻🎶"]="https://radiobarfi.com/station/radio-mirchi-98-3-fm/"
  ["ʀᴀᴅɪᴏ ᴅʜᴀᴋᴀ 90.4 📻🎶"]="https://onlinebanglaradio.com/station/dhaka-fm-90-4/"
  ["ʀᴀᴅɪᴏ ʜᴜɴɢᴀᴍᴀ 90s 📻🎶"]="https://radiobarfi.com/station/radio-hungama-90s-once-again/"
  ["ʀᴀᴅɪᴏ sᴀᴅ ᴏʟᴅ 📻🎶"]="https://radiobarfi.com/station/sad-songs-online/"
  ["ʀᴀᴅɪᴏ ʙᴏʟʟʏᴡᴏᴏᴅ ɴᴇᴡ 📻🎶"]="https://radiobarfi.com/station/bollywood-new-songs/"
  ["ʏᴛ-ʙᴀɴɢʟᴀ ʟᴏfɪ ☕️🎶"]="https://youtube.com/playlist?list=PL5mldcWb5ccAYadba77QslD8ZwpznDXrm&si=X8Zia5EjTqDs4y3S"
  ["ʏᴛ-ʜɪɴᴅɪ ʟᴏfɪ ☕️🎶"]="https://youtube.com/playlist?list=PL5mldcWb5ccCoMeoTEwJGC9V9ax-z89wu&si=_HEG25kIbus7p7hc"
  ["ʏᴛ-ᴘᴜʀᴜʟɪᴀ ᴅᴊ 🔊🎶"]="https://youtube.com/playlist?list=PL5mldcWb5ccB_Y2B2nrWGsBoZ5NtS7_OL&si=VZh1kALcTrtLXEIf"
  ["ʏᴛ-ʜɪɴᴅɪ ᴅᴊ 🔊🎶"]="https://youtube.com/playlist?list=PL5mldcWb5ccDe5hhI8FU9UPgJhbjKO4lR&si=iIc3ro08-LsN4dk-"
  ["ʏᴛ-ᴀʀᴀʙɪᴄ ʀᴇᴍɪx 🎻🎶"]="https://youtube.com/playlist?list=PL5mldcWb5ccAq_dVvoVSQlxxdLAzS4pen&si=Av0njCT3nt4UeJ4Q"
  ["ʏᴛ-ᴊᴀᴘᴀɴᴇsᴇ ʀᴇᴍɪx ☯️🎶"]="https://youtube.com/playlist?list=PL5mldcWb5ccDjEPvcDvKkpMc24NXRSNo1&si=dhW5WSI2k1LIqdHz"
  ["ʏᴛ-ɪɴᴅᴏɴᴇsɪᴀɴ ʀᴇᴍɪx 👽🎶"]="https://youtube.com/playlist?list=PL5mldcWb5ccCqwe9CAxdoI6DUCnQkCZ4u&si=4pL1cNagOJMr6uMs"
)

# Populate local_music array with files from music directory and subdirectories
populate_local_music() {
  local_music=()
  filenames=()
  while IFS= read -r file; do
    local_music+=("$file")
    filenames+=("$(basename "$file")")
  done < <(find "$mDIR" -type f \( -iname "*.mp3" -o -iname "*.flac" -o -iname "*.wav" -o -iname "*.ogg" -o -iname "*.mp4" \))
}

# Function for displaying notifications
notification() {
  notify-send -u normal -i "$iDIR/music.png" "Playing: $@"
}

# Main function for playing local music
play_local_music() {
  populate_local_music

  # Prompt the user to select a song
  choice=$(printf "%s\n" "${filenames[@]}" | rofi -i -dmenu -config ~/.config/rofi/config-rofi-Beats.rasi -p "Local Music")

  if [ -z "$choice" ]; then
    exit 1
  fi

  # Find the corresponding file path based on user's choice and set that to play the song then continue on the list
  for (( i=0; i<"${#filenames[@]}"; ++i )); do
    if [ "${filenames[$i]}" = "$choice" ]; then
		
	    notification "$choice"

      # Play the selected local music file using mpv
      mpv --playlist-start="$i" --loop-playlist --vid=no  "${local_music[@]}"

      break
    fi
  done
}

# Main function for shuffling local music
shuffle_local_music() {
  notification "Shuffle local music"

  # Play music in $mDIR on shuffle
  mpv --shuffle --loop-playlist --vid=no "$mDIR"
}

# Main function for playing online music
play_online_music() {
  choice=$(printf "%s\n" "${!online_music[@]}" | rofi -i -dmenu -config ~/.config/rofi/config-rofi-Beats.rasi -p "Online Music")

  if [ -z "$choice" ]; then
    exit 1
  fi

  link="${online_music[$choice]}"
  notification "$choice"
 cookies_file="$HOME/.config/yt-dlp/cookies.txt"
  # Check if the link is a YouTube link (for both youtube.com and youtu.be domains)
  if [[ "$link" == *"youtube.com"* || "$link" == *"youtu.be"* ]]; then
    echo "Playing YouTube content, checking for cookies..."
    # Check if cookies file exists before using it
    if [ -f "$cookies_file" ]; then
      echo "Using cookies to play $choice..."
      mpv --ytdl-raw-options=cookies="$cookies_file" --shuffle --vid=no "$link"
    else
      echo "Cookies file not found, playing without cookies..."
      mpv --shuffle --vid=no "$link"
    fi
  else
    echo "Non-YouTube content detected, playing without cookies..."
    mpv --shuffle --vid=no "$link"
  fi
}

# Check if an online music process is running and send a notification, otherwise run the main function
pkill mpv && notify-send -u low -i "$iDIR/music.png" "Music stopped" || {

# Prompt the user to choose between local and online music
user_choice=$(printf "Play from Online Stations\nPlay from Music Folder\nShuffle Play from Music Folder" | rofi -dmenu -config ~/.config/rofi/config-rofi-Beats-menu.rasi -p "Select music source")

  case "$user_choice" in
    "Play from Music Folder")
      play_local_music
      ;;
    "Play from Online Stations")
      play_online_music
      ;;
    "Shuffle Play from Music Folder")
      shuffle_local_music
      ;;
    *)
      echo "Invalid choice"
      ;;
  esac
}
