if [ "$(tty)" = "/dev/tty1" ];
then
pgrep Hyprland || exec ~/.config/hypr/scripts/starth
fi
