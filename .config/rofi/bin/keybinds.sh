#!/bin/bash

# -----------------------------------------------------
# Define keybindings.conf location
# -----------------------------------------------------
config_file=~/.config/hypr/configs/keybinds.conf
config_file=${config_file/source = ~/}
config_file=${config_file/source=~/}

# -----------------------------------------------------
# Parse keybindings
# -----------------------------------------------------
keybinds=$(grep -oP '(?<=bind = ).*' $config_file)
keybinds=$(echo "$keybinds" | sed 's/$mainMod/SUPER/g' | sed 's/,\([^,]*\)$/ = \1/' | sed 's/, exec//g' | sed 's/^,//g')

# -----------------------------------------------------
# Show keybindings in rofi
# -----------------------------------------------------
#rofi -i -dmenu -replace -p "Keybinds" -config ~/.config/rofi/themes/config-compact.rasi <<<"$keybinds"
rofi -i -dmenu -replace -p "Keybinds" -config ~/.config/rofi/themes/config-keybinds.rasi <<<"$keybinds"
