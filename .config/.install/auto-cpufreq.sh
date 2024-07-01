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

read -p "Do you want to install auto-cpufreq? (y/n): " install_choice

if [ "$install_choice" == "y" ]; then
    if ! command -v auto-cpufreq >/dev/null; then
        echo
        echo "Installing auto-cpufreq..."

        git clone https://github.com/AdnanHodzic/auto-cpufreq.git
        clear
        cd auto-cpufreq && sudo ./auto-cpufreq-installer
        sudo auto-cpufreq --install
        cd -
        sudo rm -rvf ./auto-cpufreq

        echo "auto-cpufreq installed."
    else
        echo
        echo "auto-cpufreq is already installed. Skipping..."
    fi
else
    echo "Installation of auto-cpufreq canceled by user."
fi

# Wait 2 sec before clear so user knows what happened
sleep 2
