#!/bin/bash

# Function to check if 'kitty' process is running
is_kitty_running() {
	hyprctl clients | grep 'wavemon' >/dev/null
}

# Focus on ws "7" and spawn kitty if it's not running, else only focus
if ! is_kitty_running; then
    # Spawn 'footclient' only if it was not running
    hyprctl dispatch exec 'kitty -1 --class wavewmon -e sudo wavewmon'
else
    hyprctl dispatch focuswindow '^wavemon$'
fi

