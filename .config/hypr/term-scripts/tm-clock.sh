#!/bin/bash

# Function to check if 'footclient' process is running
is_foot_running() {
	hyprctl clients | grep 'clock' >/dev/null
}

# Focus on ws "7" and spawn footclient if it's not running, else only focus
if ! is_foot_running; then
    # Spawn 'footclient' only if it was not running
    hyprctl dispatch exec 'footclient -a clock -e tty-clock -c -C 6 -r -s -f "%A, %B, %d"'
else
    hyprctl dispatch focuswindow '^clock$'
fi
