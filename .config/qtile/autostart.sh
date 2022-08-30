#!/usr/bin/env bash

VBoxClient --clipboard &
VBoxClient --seamless &
VBoxClient --checkhostversion &
picom --experimental-backends &
nitrogen --restore &
exec --no-startup -id dunst &
polybar &
