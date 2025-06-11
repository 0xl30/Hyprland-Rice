#!/bin/bash

# Colors
RED='\033[31m'
ORANGE='\033[38;5;208m'
YELLOW='\033[33m'
GREEN='\033[32m'
CYAN='\033[36m'
BLUE='\033[34m'
MAGENTA='\033[35m'
RESET='\033[0m'

print_banner() {
    echo -e "${RED}╦ ╦┬ ┬┌─┐┬─┐┬  ┌─┐┌┐┌┌┬┐   ╦═╗┬┌─┐┌─┐${RESET}"
    echo -e "${YELLOW}╠═╣└┬┘├─┘├┬┘│  ├─┤│││ ││───╠╦╝││  ├┤ ${RESET}"
    echo -e "${BLUE}╩ ╩ ┴ ┴  ┴└─┴─┘┴ ┴┘└┘─┴┘   ╩╚═┴└─┘└─┘${RESET}"
    echo "----------------------------------------------"
    echo -e "              Hyprland-Dots By ${RED}0${YELLOW}x${BLUE}R${ORANGE}y${GREEN}a${MAGENTA}n${RESET}"
    echo "----------------------------------------------"
    echo "  Backing up existing configurations in .bak"
    echo "=============================================="
    echo
}

CONFIG_DIR="$HOME/.config"
HOME_DIR="$HOME"
THEMES_DIR="$HOME/.themes"
ICONS_DIR="$HOME/.icons"
FOLDERS=("hypr" "kitty" "rofi" "fastfetch" "swaync" "waybar" "yt-dlp" "yad")
THEMES_ICON=("bluesh" "icon_bluesh")
ZSHRC=".zshrc"

# Function
backup_and_copy_folder() {
    local folder_name="$1"
    
    # Check if the folder already exists in .config
    if [ -d "$CONFIG_DIR/$folder_name" ]; then
        echo "Backing up $folder_name to $folder_name.bak"
        mv "$CONFIG_DIR/$folder_name" "$CONFIG_DIR/${folder_name}.bak"
    fi

    # Copy 
    echo "Copying $folder_name to $CONFIG_DIR"
    cp -r "$folder_name" "$CONFIG_DIR/"
}

# Function themes and icons
backup_and_copy_theme_icon() {
    local theme_name="$1"
    local dest_dir="$2"

    if [ -d "$dest_dir/$theme_name" ]; then
        echo "Backing up $theme_name in $dest_dir to $theme_name.bak"
        mv "$dest_dir/$theme_name" "$dest_dir/${theme_name}.bak"
    fi

    echo "Copying $theme_name to $dest_dir"
    cp -r "$theme_name" "$dest_dir/"
}

# Function .zshrc
backup_and_copy_zshrc() {
    local zshrc_path="$HOME_DIR/$ZSHRC"
    
    if [ -f "$zshrc_path" ]; then
        echo "Backing up .zshrc to .zshrc.bak"
        mv "$zshrc_path" "${zshrc_path}.bak"
    fi

    echo "Copying .zshrc to $HOME_DIR"
    cp "$ZSHRC" "$HOME_DIR/"
}

print_banner
for folder in "${FOLDERS[@]}"; do
    backup_and_copy_folder "$folder"
done

backup_and_copy_zshrc

backup_and_copy_theme_icon "bluesh" "$THEMES_DIR"
backup_and_copy_theme_icon "icon_bluesh" "$ICONS_DIR"

echo
echo "=============================================="
echo -e " ${RED}If You Face Any Problem,${RESET}"
echo -e " ${WHITE}Don't Forget to Ping Me on Social Media${RESET}"
echo -e " ${GREEN}Linkedin:${RESET} ${MAGENTA}0${ORANGE}x${YELLOW}l${GREEN}3${CYAN}0${RESET}, ${BLUE}Facebook:${RESET} ${MAGENTA}0${ORANGE}x${YELLOW}l${GREEN}3${CYAN}0${RESET}"
echo "=============================================="
