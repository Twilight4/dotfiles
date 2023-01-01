if [ "$(tty)" = "/dev/tty1" ];
then
pgrep Hyprland || exec ~/.config/.local/bin/wrappedh1
fi
