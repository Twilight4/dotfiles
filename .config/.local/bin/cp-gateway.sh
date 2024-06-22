#!/usr/bin/env bash

if ifconfig | grep -q "wlo1"; then
    ip_address_0=$(ip route | grep via | grep wlo1 | cut -d" " -f3)
    notify-send -t 3000 "Gateway IP Address:" "$ip_address_0"
    echo "$ip_address_0" | wl-copy
elif ifconfig | grep -q "wlan0"; then
    ip_address_1=$(ip route | grep via | grep wlan0 | cut -d" " -f3)
    notify-send -t 3000 "Gateway IP Address:" "$ip_address_1"
    echo "$ip_address_1" | wl-copy
else
    notify-send -t 3000 "Interface not found"
fi

