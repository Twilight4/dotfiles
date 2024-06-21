#!/bin/bash

# Function to check if 'kitty' process is running
is_kitty_running() {
	hyprctl clients | grep 'nuke-system' >/dev/null
}

# Spawn 'kitty' if it's not running, else only focus
if ! is_kitty_running; then
    # Spawn 'kitty' only if it was not running
    hyprctl dispatch exec 'kitty -1 -T nuke-system --class nuke-system -e ~/.config/.local/bin/nuke-system/nuke-system.sh'
else
    hyprctl dispatch focuswindow '^nuke-system$'
fi
