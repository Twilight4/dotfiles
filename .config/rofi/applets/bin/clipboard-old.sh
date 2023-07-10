#!/usr/bin/env bash

theme="launcher/style.rasi"
dir="$HOME/.config/rofi"

if [[ "$XDG_SESSION_DESKTOP" == "Hyprland" ]]; then
	cliphist list | rofi -p \
		pick -dmenu -i -theme \
		"$dir/$theme" -lines 10 | cliphist decode | wl-copy
else
	rofi -modi "clipboard:greenclip print" \
		-show clipboard \
		-run-command '{cmd}' \
		-theme "$dir/""$theme"
fi
