#!/bin/bash

if [ $disman == 1 ]; then
	cat <<"EOF"
____  _           _               __  __                                   
|  _ \(_)___ _ __ | | __ _ _   _  |  \/  | __ _ _ __   __ _  __ _  ___ _ __ 
| | | | / __| '_ \| |/ _` | | | | | |\/| |/ _` | '_ \ / _` |/ _` |/ _ \ '__|
| |_| | \__ \ |_) | | (_| | |_| | | |  | | (_| | | | | (_| | (_| |  __/ |   
|____/|_|___/ .__/|_|\__,_|\__, | |_|  |_|\__,_|_| |_|\__,_|\__, |\___|_|   
            |_|            |___/                            |___/

EOF

	while true; do
		read -p "Do you want to install SDDM with theme (Yy/Nn): " yn
		case $yn in
		[Yy]*)
			_installPackagesParu sddm-git
			_installPackagesParu sddm-sugar-candy-git

			echo "Creating /etc/sddm.conf file..."
			sudo mv /etc/sddm.conf /etc/sddm.conf.bak

			# Clone the sddm.conf config file
			curl -LJO https://raw.githubusercontent.com/Twilight4/dotfiles/main/.config/sddm/sddm.conf && sudo mv sddm.conf /etc/sddm.conf

			# Apply the wallpaper background to sddm
			curl -LJO https://raw.githubusercontent.com/Twilight4/dotfiles/refs/heads/main/.config/sddm/default.png && sudo mv default.png /usr/share/sddm/themes/sugar-candy/Backgrounds/default.png

			# Clone the theme.conf config file
			curl -LJO https://raw.githubusercontent.com/Twilight4/dotfiles/main/.config/sddm/theme.conf && sudo mv theme.conf /usr/share/sddm/themes/sugar-candy/theme.conf

			echo "/etc/sddm.conf file created."
			break
			;;
		[Nn]*)
			echo "SDDM setup skipped."
			break
			;;
		*) echo "Please answer yes or no." ;;
		esac
	done
	echo ""
fi
