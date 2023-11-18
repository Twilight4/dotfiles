#!bin/bash

cat <<"EOF"
             _                                __                
  __ _ _   _| |_ ___         ___ _ __  _   _ / _|_ __ ___  __ _ 
 / _` | | | | __/ _ \ _____ / __| '_ \| | | | |_| '__/ _ \/ _` |
| (_| | |_| | || (_) |_____| (__| |_) | |_| |  _| | |  __/ (_| |
 \__,_|\__,_|\__\___/       \___| .__/ \__,_|_| |_|  \___|\__, |
                                |_|                          |_|
EOF

if [ "$install_choice" == "y" ]; then
    if ! command -v auto-cpufreq >/dev/null; then
        echo "Installing auto-cpufreq..."

        git clone https://github.com/AdnanHodzic/auto-cpufreq.git
        cd auto-cpufreq && sudo ./auto-cpufreq-installer
        sudo auto-cpufreq --install
        cd -
        sudo rm -rf ./auto-cpufreq

        echo "auto-cpufreq installed."
    else
        echo "auto-cpufreq is already installed."
    fi
else
    echo "Installation of auto-cpufreq canceled by user."
fi
