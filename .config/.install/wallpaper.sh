#!/bin/bash

cat <<"EOF"
               _ _                                 
__      ____ _| | |_ __   __ _ _ __   ___ _ __ ___ 
\ \ /\ / / _` | | | '_ \ / _` | '_ \ / _ \ '__/ __|
 \ V  V / (_| | | | |_) | (_| | |_) |  __/ |  \__ \
  \_/\_/ \__,_|_|_| .__/ \__,_| .__/ \___|_|  |___/
                  |_|         |_|                  

EOF

echo "Do you want to download the wallpapers from repository https://github.com/Twilight4/wallpapers.git ?"
while true; do
	read -p "(Yy/Nn): " yn
	case $yn in
	[Yy]*)
    if [ -d ~/pictures/wallpapers ]; then
        rm -rf ~/pictures/wallpapers 2>&1 | tee -a "$LOG"
    fi
		mkdir -p ~/pictures/
		git clone --depth 1 https://github.com/Twilight4/wallpapers ~/pictures/wallpapers
		rm -rf ~/pictures/wallpapers/.git
		echo "Wallpapers installed successfully."
		break
		;;
	[Nn]*)
		mkdir -p ~/pictures/wallpapers
		curl -LO https://raw.githubusercontent.com/Twilight4/wallpapers/main/default.jpg && mv default.jpg ~/pictures/wallpapers/default.jpg
		echo "Default wallpaper installed successfully."
		break
		;;
	*) echo "Please answer y/n." ;;
	esac
done
echo ""

# ------------------------------------------------------
# Copy default wallpaper to .cache
# ------------------------------------------------------
cp ~/pictures/wallpapers/default.jpg ~/.cache/current_wallpaper.jpg
echo ""

# GTK Themes for flatpak
sudo flatpak override --filesystem=$HOME/.config/.local/share/themes
sudo flatpak override --filesystem=$HOME/.config/.local/share/icons
sudo flatpak override --filesystem=xdg-config/gtk-4.0
