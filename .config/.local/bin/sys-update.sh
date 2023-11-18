#!bin/bash

notify-send -u low -t 4000 -i "$HOME/.config/mako/icons/update.png" "Updating system..." 

sudo pacman --noconfirm -Syu ; echo Done - Press enter to exit; read _"
