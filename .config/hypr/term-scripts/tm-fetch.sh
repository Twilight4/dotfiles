#!/bin/bash

# Function to check if 'kitty' process is running
is_kitty_running() {
	hyprctl clients | grep 'fetch' >/dev/null
}

# Spawn 'kitty' if it's not running, else only focus
if ! is_kitty_running; then
    hyprctl dispatch exec 'kitty -1 --hold --class fetch -e fastfetch --kitty ~/pictures/screenshots/Patrick-Bateman-Profile-Pic_600x600.jpg'
else
    hyprctl dispatch focuswindow '^fetch$'
fi
