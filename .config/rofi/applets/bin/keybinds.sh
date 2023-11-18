#!/bin/bash

# ----------------------------------------------------- 
# Define keybindings location
# ----------------------------------------------------- 
config_file=~/.config/hypr/configs/keybinds.conf

# ----------------------------------------------------- 
# Parse keybindings
# ----------------------------------------------------- 
keybinds=$(grep -oP '(?<=bind = ).*' $config_file)
keybinds=$(echo "$keybinds" | sed 's/$mainMod/SUPER/g'|  sed 's/,\([^,]*\)$/ = \1/' | sed 's/, exec//g' | sed 's/^,//g')

# ----------------------------------------------------- 
# Show keybindings in rofi
# ----------------------------------------------------- 
rofi -dmenu -replace -p "Keybinds" -config ~/.config/rofi/configs/config-compact.rasi <<< "$keybinds"
