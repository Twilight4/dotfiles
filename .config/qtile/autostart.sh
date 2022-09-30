#!/bin/sh

# VBox
VBoxClient --clipboard &
VBoxClient --seamless &
VBoxClient --checkhostversion &

# Bare Metal
picom --experimental-backends &
nitrogen --restore &
exec --no-startup -id dunst &
bash ~/.config/polybar/launch.sh

#Network
#nm-applet &

# Bluetooth
#blueman-applet &

# systray battery icon
## cbatticon -u 5 &

# systray volume
#volumeicon &
