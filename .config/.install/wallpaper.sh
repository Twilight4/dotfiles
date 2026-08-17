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

if [[ -d $HOME/pictures/wallpapers ]]; then
    rm -rf "$HOME/pictures/wallpapers"
fi
mkdir -pv "$HOME/pictures/"
mkdir -pv "$HOME/.cache/"
git clone --depth 1 https://github.com/Twilight4/wallpapers "$HOME/pictures/wallpapers"
rm -rf "$HOME/pictures/wallpapers/.git"
if [[ -f $HOME/pictures/wallpapers/aesthetic-wallpapers/default.png ]]; then
    cp -v "$HOME/pictures/wallpapers/aesthetic-wallpapers/default.png" "$HOME/.cache/"
    ok "Copied default.png"
else
    warn "default.png does not exist."
fi
echo
ok "Wallpapers installed successfully."
