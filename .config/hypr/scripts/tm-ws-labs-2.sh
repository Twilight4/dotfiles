#!/bin/bash

hyprctl dispatch exec 'kitty -T cpu-temp --class cpu-temp -e watch -n 0.5 sensors zenpower-pci-00c3'
hyprctl dispatch exec 'kitty -T fans --class fans -e watch -n 0.5 sudo ~/.config/.local/bin/omen-fan i'
hyprctl dispatch exec 'kitty -T htop --class htop -e htop'
hyprctl dispatch exec 'kitty -T nvtop --class nvtop -e nvtop'
hyprctl dispatch exec 'kitty -T wavemon --class wavemon -e wavemon'
#btop
