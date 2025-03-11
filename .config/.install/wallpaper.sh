#!/bin/bash

clear
cat <<"EOF"
               _ _                                 
__      ____ _| | |_ __   __ _ _ __   ___ _ __ ___ 
\ \ /\ / / _` | | | '_ \ / _` | '_ \ / _ \ '__/ __|
 \ V  V / (_| | | | |_) | (_| | |_) |  __/ |  \__ \
  \_/\_/ \__,_|_|_| .__/ \__,_| .__/ \___|_|  |___/
                  |_|         |_|                  

EOF

# Prompt the user
read -p "This will clone Twilight4/wallpapers repository. Press any key to continue or Ctrl+C to exit..." -n 1 -s
echo

if [ -d ~/pictures/wallpapers ]; then
    rm -rvf ~/pictures/wallpapers
fi
mkdir -vp ~/pictures/
mkdir -vp ~/.cache/
git clone --depth 1 https://github.com/Twilight4/wallpapers ~/pictures/wallpapers
rm -rvf ~/pictures/wallpapers/.git
[ -f ~/pictures/wallpapers/aesthetic-wallpapers/default.png ] && cp -v ~/pictures/wallpapers/aesthetic-wallpapers/default.png ~/.cache/ && echo "Copied default.png" || echo "default.png does not exist."
echo
echo "Wallpapers installed successfully."

# Wait 2 sec before clear so user knows what happened
sleep 2
