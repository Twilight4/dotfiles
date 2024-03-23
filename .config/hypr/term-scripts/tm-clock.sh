#!/bin/bash

# Function to check if 'kitty' process is running
is_kitty_running() {
	hyprctl clients | grep 'clock' >/dev/null
}

# Focus on ws "7" and spawn kitty if it's not running, else only focus
if ! is_kitty_running; then
    # Spawn 'footclient' only if it was not running
    hyprctl dispatch exec 'kitty -1 --class clock -e tty-clock -c -C 6 -r -s -f "%A, %B, %d"'
else
    hyprctl dispatch focuswindow '^clock$'
fi
