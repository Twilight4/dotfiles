#!/bin/bash

clear
cat <<"EOF"
 _                    _           
| |    ___   ___ __ _| | ___  ___ 
| |   / _ \ / __/ _` | |/ _ \/ __|
| |__| (_) | (_| (_| | |  __/\__ \
|_____\___/ \___\__,_|_|\___||___/
                                  
EOF

# Prompt the user
read -p "This will correct the data locale to English. Press any key to continue or Ctrl+C to exit..." -n 1 -s
echo

if [[ "$(localectl status)" != *"LC_TIME=en_US.UTF-8"* ]]; then
    echo "Setting LC_TIME to English..."
    sudo localectl set-locale LC_TIME=en_US.UTF-8
    sudo localectl set-locale LC_MONETARY=en_US.UTF-8
    sudo localectl set-locale LC_NUMERIC=en_US.UTF-8
    echo "LC_TIME set to English."
else
    echo "LC_TIME is already set to English."
fi

# Wait 2 sec before clear so user knows what happened
sleep 2
