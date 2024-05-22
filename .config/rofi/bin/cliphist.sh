#!/bin/bash

case $1 in
    d) cliphist list | rofi -i -dmenu -replace -config ~/.config/rofi/configs/config-compact.rasi | cliphist delete
       ;;

    w) if [ `echo -e "Clear\nCancel" | rofi -i -dmenu -config ~/.config/rofi/configs/config-short.rasi` == "Clear" ] ; then
            cliphist wipe
       fi
       ;;

    *) cliphist list | rofi -i -dmenu -replace -config ~/.config/rofi/configs/config-compact.rasi | cliphist decode | wl-copy
       ;;
esac
