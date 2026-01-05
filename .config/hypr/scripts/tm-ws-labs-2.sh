#!/bin/bash

hyprctl dispatch exec 'kitty -T cpu-temp --class cpu-temp -e watch -n 0.5 sensors zenpower-pci-00c3'
hyprctl dispatch exec 'kitty -T htop-btop-ptop --class htop-btop-ptop --session ~/.config/kitty/session-float'
hyprctl dispatch exec 'kitty -T nvtop --class nvtop -e nvtop'
hyprctl dispatch exec 'kitty -T wavemon --class wavemon -e wavemon'
