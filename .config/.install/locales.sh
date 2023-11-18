#!bin/bash

cat <<"EOF"
 _                 _           
| | ___   ___ __ _| | ___  ___ 
| |/ _ \ / __/ _` | |/ _ \/ __|
| | (_) | (_| (_| | |  __/\__ \
|_|\___/ \___\__,_|_|\___||___/
                               
EOF

read -p "Do you want to correct the data locale to English? (y/n): " locale_choice

if [[ "$locale_choice" =~ ^[Yy]$ ]]; then
    if [[ "$(localectl status)" != *"LC_TIME=en_US.UTF-8"* ]]; then
        echo "Setting LC_TIME to English..."
        sudo localectl set-locale LC_TIME=en_US.UTF-8
        sudo localectl set-locale LC_MONETARY=en_US.UTF-8
        sudo localectl set-locale LC_NUMERIC=en_US.UTF-8
        echo "LC_TIME set to English."
    else
        echo "LC_TIME is already set to English."
    fi
else
    echo "Correction of data locale to English canceled by user."
fi
