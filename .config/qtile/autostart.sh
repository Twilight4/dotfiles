#!/bin/sh

# VBox
VBoxClient --clipboard &
VBoxClient --seamless &
VBoxClient --checkhostversion &

# Bare Metal
picom --experimental-backends &
nitrogen --restore &
exec --no-startup -id dunst &
#polybar &

#Network
#nm-applet &

# Bluetooth
#blueman-applet &

# systray battery icon
## cbatticon -u 5 &

# systray volume
#volumeicon &
