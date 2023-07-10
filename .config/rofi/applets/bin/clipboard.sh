#!/usr/bin/env bash

CONFIG="$HOME/.config/rofi/config"
STYLE="$HOME/.config/rofi/style.css"
#COLORS="$HOME/.config/rofi/colors"

if [[ "$XDG_SESSION_DESKTOP" == "Hyprland" ]]; then
	cliphist list | wofi --dmenu \
    --conf ${CONFIG} --style ${STYLE} --color ${COLORS} \
    --width=350 --height=380 \
    --cache-file=/dev/null \
    --hide-scroll --no-actions | cliphist decode | wl-copy
else
  return
fi
