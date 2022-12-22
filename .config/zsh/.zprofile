if [ "$(tty)" = "/dev/tty1" ];
then
pgrep Hyprland || exec ~/.local/bin/wrappedh1
fi
