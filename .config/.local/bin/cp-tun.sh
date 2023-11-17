#!/usr/bin/env bash

if ifconfig | grep -q "tun0"; then
    ip_address=$(ifconfig tun0 | rg "inet " | cut -b 9- | cut  -d" " -f2)
    notify-send -t 3000 "tun0 IP Address:" "$ip_address"
    echo "$ip_address" | wl-copy
else
    notify-send -t 3000 "Interface not found"
fi
