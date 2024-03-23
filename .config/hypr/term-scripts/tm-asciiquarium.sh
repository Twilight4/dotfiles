#!/bin/bash

# Function to check if 'kitty' process is running
is_kitty_running() {
	hyprctl clients | grep 'asciiquarium' >/dev/null
}

# Focus on ws "7" and spawn kitty if it's not running, else only focus
if ! is_kitty_running; then
    # Spawn 'footclient' only if it was not running
    hyprctl dispatch exec 'kitty --class asciiquarium -e asciiquarium'
else
    hyprctl dispatch focuswindow '^asciiquarium$'
fi
