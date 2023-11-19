#!/bin/bash

# Function to check if 'ffplay' process is running
is_webcam_running() {
	hyprctl clients | grep 'ffplay' >/dev/null
}

# Spawn webcam if it's not running, else only focus
if ! is_webcam_running; then
    # Spawn 'webcam.sh' only if it was not running
    hyprctl dispatch exec 'webcam.sh'
else
    hyprctl dispatch focuswindow '^ffplay$'
fi
