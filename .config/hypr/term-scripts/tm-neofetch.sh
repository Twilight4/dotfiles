#!/bin/bash

# Function to check if 'footclient' process is running
is_foot_running() {
	hyprctl clients | grep 'neofetch' >/dev/null
}

# Focus on ws "7" and spawn footclient if it's not running, else only focus
if ! is_foot_running; then
    # Spawn 'footclient' only if it was not running
    hyprctl dispatch exec 'kitty -1 --hold --class neofetch -e neofetch -a --kitty ~/desktop/workspace/dotfiles/.config/emacs/assets/dash.png'
else
    hyprctl dispatch focuswindow '^neofetch$'
fi
