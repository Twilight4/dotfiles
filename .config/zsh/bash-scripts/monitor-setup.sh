#!/bin/bash

if [ -f "/tmp/toggle-gamemode" ]; then
    rm "/tmp/toggle-gamemode"
    notify-send -t 3000 "Gamemode Disabled"
    riverctl unmap normal Shift D
    riverctl unmap normal Shift W
    riverctl unmap normal Shift E
else
    touch "/tmp/toggle-gamemode"
    notify-send -t 3000 "Gamemode Enabled"
    riverctl map normal Shift D spawn '~/.config/river/scripts/s-d.sh'
    riverctl map normal Shift W spawn '~/.config/river/scripts/s-w.sh'
    riverctl map normal Shift E spawn '~/.config/river/scripts/s-e.sh'
    if (wlr-randr | grep -q "eDP-1" ); then
        enabled_line=$(wlr-randr | grep -n "eDP-1" | head -n 1 | cut -d ':' -f 1)
        enabled_status=$(wlr-randr | awk -v line=$((enabled_line + 5)) 'NR==line {print $0}')
        if [ "$enabled_status" = "  Enabled: yes" ]; then
            wlr-randr --output eDP-1 --off
            wlr-randr --output DP-2 --mode 1920x1080@165 --pos 0,0 --transform normal --scale 1.000000
        fi
    fi
fi
