if [ "$(tty)" = "/dev/tty1" ];
then
pgrep qtile || exec startx "$XDG_CONFIG_HOME/x11/xinitrc"
fi
