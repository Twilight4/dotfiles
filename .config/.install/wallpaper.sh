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
    [ -f ~/pictures/wallpapers/default.jpg ] && cp ~/pictures/wallpapers/default.jpg ~/.cache/current_wallpaper.jpg && echo "Copied default.jpg" || echo "default.jpg does not exist."
    [ -f ~/pictures/wallpapers/lady.png ] && cp ~/pictures/wallpapers/lady.png ~/.cache/lady.png && echo "Copied lady.png" || echo "lady.png does not exist."
		break
		;;
	[Nn]*)
		mkdir -p ~/pictures/wallpapers
		curl -LO https://raw.githubusercontent.com/Twilight4/wallpapers/main/default.jpg && mv default.jpg ~/pictures/wallpapers/default.jpg
		curl -LO https://raw.githubusercontent.com/Twilight4/wallpapers/main/lady.png && mv lady.png ~/.cache/lady.png
		echo "Default wallpaper installed successfully."
		break
		;;
	*) echo "Please answer y/n." ;;
	esac
done
echo ""

# GTK Themes for flatpak
sudo flatpak override --filesystem=$HOME/.config/.local/share/themes
sudo flatpak override --filesystem=$HOME/.config/.local/share/icons
sudo flatpak override --filesystem=xdg-config/gtk-4.0
