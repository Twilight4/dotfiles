if [ "$(tty)" = "/dev/tty1" ];
then
pgrep Hyprland || exec start-hyprland
fi
