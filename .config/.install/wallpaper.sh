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

install_full_repo() {
    if [ -d ~/pictures/wallpapers ]; then
        rm -rvf ~/pictures/wallpapers 2>&1 | tee -a "$LOG"
    fi
    mkdir -vp ~/pictures/
    mkdir -vp ~/.cache/
    git clone --depth 1 https://github.com/Twilight4/wallpapers ~/pictures/wallpapers
    rm -rvf ~/pictures/wallpapers/.git
    echo "Wallpapers installed successfully."
    [ -f ~/pictures/wallpapers/default.jpg ] && cp -v ~/pictures/wallpapers/default.jpg ~/.cache/ && echo "Copied default.jpg" || echo "default.jpg does not exist."
    [ -f ~/pictures/wallpapers/lady.png ] && cp -v ~/pictures/wallpapers/lady.png ~/.cache/ && echo "Copied lady.png" || echo "lady.png does not exist."
}

install_default_wallpaper() {
    mkdir -vp ~/pictures/wallpapers
    curl -LO https://raw.githubusercontent.com/Twilight4/wallpapers/main/default.jpg && mv default.jpg ~/pictures/wallpapers/default.jpg
    curl -LO https://raw.githubusercontent.com/Twilight4/wallpapers/main/lady.png && mv lady.png ~/.cache/lady.png
    echo
    echo "Default wallpaper installed successfully."
}

main() {
    echo "Please choose an option:"
    echo "1. Install full wallpapers repository"
    echo "2. Install only the default wallpaper"
    echo "3. Skip installation"
    echo
    read -p "Enter your choice (1/2/3): " choice
    case $choice in
        1)
            echo
            install_full_repo
            ;;
        2)
            echo
            install_default_wallpaper
            ;;
        3)
            echo "Installation skipped."
            ;;
        *)
            echo "Invalid choice. Please enter 1, 2, or 3."
            main
            ;;
    esac
}

main

# Wait 2 sec before clear so user knows what happened
sleep 2
