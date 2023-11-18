#!/bin/bash

if [ $(ip a s | grep tun0 | grep inet | awk '{print $2;}' | cut -d . -f2 | tr -d '\n' | wc -c) -eq 2 ]; then
  echo "ON"
elif [ $(ip a s | grep tun0 | grep inet | awk '{print $2;}' | cut -d . -f2 | tr -d '\n' | wc -c) -eq 0 ]; then
  echo "OFF"
fi
