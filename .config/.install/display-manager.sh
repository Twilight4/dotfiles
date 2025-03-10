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

# Prompt the user
read -p "This will configure SDDM display manager. Press any key to continue or Ctrl+C to exit..." -n 1 -s
echo

echo "Creating /etc/sddm.conf file..."
sudo mv /etc/sddm.conf /etc/sddm.conf.bak

# Clone the sddm.conf config file
curl -LJO https://raw.githubusercontent.com/Twilight4/dotfiles/main/.config/sddm/sddm.conf && sudo mv sddm.conf /etc/sddm.conf

# Download the default.png image
curl -LJO https://raw.githubusercontent.com/Twilight4/dotfiles/refs/heads/main/.config/sddm/melbourne.jpg && sudo mv melbourne.jpg /usr/share/sddm/themes/sugar-candy/Backgrounds/melbourne.jpg

# Change the default background image to default.png image
sudo sed -i 's|Background="Backgrounds/Mountain.jpg"|Background="Backgrounds/melbourne.jpg"|g' /usr/share/sddm/themes/sugar-candy/theme.conf

# Clone the theme.conf config file
curl -LJO https://raw.githubusercontent.com/Twilight4/dotfiles/main/.config/sddm/theme.conf && sudo mv theme.conf /usr/share/sddm/themes/sugar-candy/theme.conf

echo "/etc/sddm.conf file created."

# Wait 2 sec before clear so user knows what happened
sleep 2
