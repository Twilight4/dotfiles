if [ "$(tty)" = "/dev/tty1" ];
then
pgrep bspwm || exec startx "$XDG_CONFIG_HOME/x11/xinitrc"
fi
