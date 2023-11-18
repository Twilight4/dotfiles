#!bin/bash

cat <<"EOF"
__        __    _ _                                 
\ \      / /_ _| | |_ __   __ _ _ __   ___ _ __ ___ 
 \ \ /\ / / _` | | | '_ \ / _` | '_ \ / _ \ '__/ __|
  \ V  V / (_| | | | |_) | (_| | |_) |  __/ |  \__ \
   \_/\_/ \__,_|_|_| .__/ \__,_| .__/ \___|_|  |___/
                   |_|         |_|                  
EOF

echo "Do you want to download the wallpapers from repository https://github.com/Twilight4/wallpapers/ ?"
while true; do
    read -p "(Yy/Nn): " yn
    case $yn in
        [Yy]* )
            git clone --depth 1 https://github.com/Twlight4/wallpapers ~/pictures/wallpapers
            echo "Wallpapers installed successfully."
        break;;
        [Nn]* ) 
            if [ -d ~/pictures/wallpapers/ ]; then
                echo "Wallpaper directory already exists."
            else
                mkdir -p ~/pictures/wallpapers
				cp .config/wallpapers/* ~/pictures/wallpapers
				echo "Default wallpapers installed successfully."
            fi
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done
echo ""

# ------------------------------------------------------
# Copy default wallpaper to .cache
# ------------------------------------------------------
cp .config/wallpapers/default.jpg ~/.cache/current_wallpaper.jpg
echo ""
