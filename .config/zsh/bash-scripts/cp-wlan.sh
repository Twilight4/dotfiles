#!/usr/bin/env bash

if ifconfig | grep -q "wlo1"; then
    ip_address_0=$(ifconfig wlo1 | rg "inet " | cut -b 9- | cut  -d" " -f2)
    notify-send -t 3000 "wlo1 IP Address:" "$ip_address_0"
    echo "$ip_address_0" | wl-copy
if
    ip_address_1=$(ifconfig wlan0 | rg "inet " | cut -b 9- | cut  -d" " -f2)
    notify-send -t 3000 "wlan0 IP Address:" "$ip_address_1"
    echo "$ip_address_1" | wl-copy
else
    notify-send -t 3000 "Interface not found"
fi

