#!/bin/bash

hyprctl dispatch exec 'uwsm app -- kitty -T asciiquarium --class asciiquarium -e asciiquarium --transparent'
hyprctl dispatch exec 'uwsm app -- kitty -T cava --class cava -e cava'
hyprctl dispatch exec 'uwsm app -- kitty -T clock --class clock -e tty-clock -c -C 6 -r -s -f "%A, %B, %d"'
hyprctl dispatch exec 'uwsm app -- kitty -T cmatrix --class cmatrix -e cmatrix'
hyprctl dispatch exec 'uwsm app -- kitty -T musikcube --class musikcube -e musikcube'
hyprctl dispatch exec 'uwsm app -- kitty -T pipes --class pipes -e ~/.config/zsh/bash-scripts/pipes'
hyprctl dispatch exec 'uwsm app -- kitty -T rain --class rain -e ~/.config/zsh/bash-scripts/rain'
hyprctl dispatch exec 'uwsm app -- kitty --hold -T fetch --class fetch -e fastfetch --kitty ~/pictures/screenshots/Patrick-Bateman-Profile-Pic_600x600.jpg'
hyprctl dispatch exec 'uwsm app -- kitty -T cpufetch --class cpufetch -e cpufetch'
hyprctl dispatch exec 'uwsm app -- kitty --class fireplace -T fireplace -e fireplace'
hyprctl dispatch exec 'uwsm app -- kitty -T cbonsai --class cbonsai -e cbonsai --live'
