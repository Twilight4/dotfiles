#!/bin/bash

hyprctl dispatch exec 'kitty -T asciiquarium --class asciiquarium -e asciiquarium --transparent'
hyprctl dispatch exec 'kitty -T cava --class cava -e cava'
hyprctl dispatch exec 'kitty -T clock --class clock -e tty-clock -c -C 6 -r -s -f "%A, %B, %d"'
hyprctl dispatch exec 'kitty -T cmatrix --class cmatrix -e cmatrix'
hyprctl dispatch exec 'kitty -T musikcube --class musikcube -e musikcube'
hyprctl dispatch exec 'kitty -T pipes --class pipes -e ~/.config/zsh/bash-scripts/pipes'
hyprctl dispatch exec 'kitty -T rain --class rain -e ~/.config/zsh/bash-scripts/rain'
hyprctl dispatch exec 'kitty --hold -T fetch --class fetch -e fastfetch --kitty ~/pictures/screenshots/Patrick-Bateman-Profile-Pic_600x600.jpg'
hyprctl dispatch exec 'kitty -T cpufetch --class cpufetch -e cpufetch'
hyprctl dispatch exec 'kitty --class fireplace -T fireplace -e fireplace'
