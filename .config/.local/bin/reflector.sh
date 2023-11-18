#!bin/bash

notify-send -u low -t 4000 -i "$HOME/.config/mako/icons/mirror.png" "Updating mirrors..." 

sudo reflector --score 100 --fastest 10 --number 10 --verbose --save /etc/pacman.d/mirrorlist ; echo Done - Press enter to exit; read _"
