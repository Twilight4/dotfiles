#!/bin/bash

# Files
CONFIG="$HOME/.config/rofi/config"
STYLE="$HOME/.config/rofi/style.css"
#COLORS="$HOME/.config/rofi/colors"

# Wofi Command
wofi_command="wofi --show dmenu \
      -i \
      --conf ${CONFIG} --style ${STYLE} --color ${COLORS} \
      --width=350 --height=380 \
      --cache-file=/dev/null \
      --hide-scroll --no-actions \
      --prompt 'Search live streams'
      --define=matching=fuzzy"


notification(){
  notify-send "Lofi Stream" "Now Playing: Lofi Radio"
}

menu(){
  printf "1. Lofi Girl\n"
  printf "2. 2AM Playlist\n"
  printf "3. Good Life Radio\n"
}

main() {
  choice=$(menu | ${wofi_command} | cut -d. -f1)

  case $choice in
    1)
      notification
      mpv "https://play.streamafrica.net/lofiradio"
      return
      ;;
    2)
      notification
      kitty -1 --class kitty-radio -T kitty-radio --detach mpv --no-input-builtin-bindings --profile=sw-fast --vo=kitty "https://youtube.com/playlist?list=PLf6avsc1ieWNKvqo8iXhRtrpHnU0M7SbI&si=I48eEnZXQEx9_XWs"
      kitty -1 -T cava --class cava -e cava
      return
      ;;
    3)
      notification
      kitty -1 --class kitty-radio -T kitty-radio --detach mpv --no-input-builtin-bindings --profile=sw-fast --vo=kitty "https://www.youtube.com/watch?v=36YnV9STBqc"
      kitty -1 -T cava --class cava -e cava
      return
      ;;	
  esac
}

pkill -f http && notify-send "Lofi Stream" "Lofi Radio stopped" || main
