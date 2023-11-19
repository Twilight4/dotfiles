#!/bin/bash

# Function to check if 'footclient' process is running
is_foot_running() {
	hyprctl clients | grep 'asciiquarium' >/dev/null
}

# Focus on ws "7" and spawn footclient if it's not running, else only focus
if ! is_foot_running; then
    # Spawn 'footclient' only if it was not running
    hyprctl dispatch exec 'footclient -a asciiquarium -e asciiquarium'
else
    hyprctl dispatch focuswindow '^asciiquarium$'
fi
