#!/bin/bash

clear
cat <<"EOF"
             _                                __                
  __ _ _   _| |_ ___         ___ _ __  _   _ / _|_ __ ___  __ _ 
 / _` | | | | __/ _ \ _____ / __| '_ \| | | | |_| '__/ _ \/ _` |
| (_| | |_| | || (_) |_____| (__| |_) | |_| |  _| | |  __/ (_| |
 \__,_|\__,_|\__\___/       \___| .__/ \__,_|_| |_|  \___|\__, |
                                |_|                          |_|

EOF

# Prompt the user
read -p "This will install auto-cpufreq. Press any key to continue or Ctrl+C to exit..." -n 1 -s
echo

if ! command -v auto-cpufreq >/dev/null; then
    echo
    echo "Installing auto-cpufreq..."

    git clone https://github.com/AdnanHodzic/auto-cpufreq.git
    clear
    cd auto-cpufreq && sudo ./auto-cpufreq-installer
    # To disable and remove auto-cpufreq daemon, run: sudo auto-cpufreq --remove
    sudo auto-cpufreq --install
    cd -
    sudo rm -rvf ./auto-cpufreq

    echo "auto-cpufreq installed."
else
    echo
    echo "auto-cpufreq is already installed. Skipping..."
fi

# Wait 2 sec before clear so user knows what happened
sleep 2
