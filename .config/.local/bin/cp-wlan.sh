#!/usr/bin/env bash

if ifconfig | grep -q "wlo1"; then
    ip_address_0=$(ifconfig wlo1 | grep 'inet ' | awk '{print $2}')
    notify-send -t 3000 "wlo1 IP Address:" "$ip_address_0"
    echo "$ip_address_0" | wl-copy
elif ifconfig | grep -q "wlan0"; then
    ip_address_1=$(ifconfig wlan0 | grep 'inet ' | awk '{print $2}')
    notify-send -t 3000 "wlan0 IP Address:" "$ip_address_1"
    echo "$ip_address_1" | wl-copy
else
    notify-send -t 3000 "Interface not found"
fi

