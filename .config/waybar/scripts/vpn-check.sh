#!/bin/bash

if [ $(ip a s | grep tun0 | grep inet | awk '{print $2;}' | cut -d . -f2 | tr -d '\n' | wc -c) -eq 3 ]; then
  echo "ON"
elif [ $(ip a s | grep tun0 | grep inet | awk '{print $2;}' | cut -d . -f2 | tr -d '\n' | wc -c) -eq 1 ]; then
  echo "OFF"
fi
