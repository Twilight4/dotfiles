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
curl -LJO https://raw.githubusercontent.com/Twilight4/dotfiles/refs/heads/main/.config/sddm/avatar.jpg && sudo mv avatar.jpg /usr/share/sddm/themes/pixie/assets/avatar.jpg 

# Clone the theme.conf config file
curl -LJO https://raw.githubusercontent.com/Twilight4/dotfiles/main/.config/sddm/theme.conf && sudo mv theme.conf /usr/share/sddm/themes/pixie/theme.conf

# Clone the Main.qml config file
curl -LJO https://raw.githubusercontent.com/Twilight4/dotfiles/main/.config/sddm/Main.qml && sudo mv Main.qml /usr/share/sddm/themes/pixie/Main.qml

# Make only one hyprland session and remove the other bloat ones from UI
sudo mv /usr/share/wayland-sessions/garuda-hyprland.desktop /usr/share/wayland-sessions/garuda-hyprland.desktop.disabled
sudo mv /usr/share/wayland-sessions/hyprland.desktop /usr/share/wayland-sessions/hyprland.desktop.disabled
sudo mv /usr/share/wayland-sessions/hyprland-uwsm.desktop /usr/share/wayland-sessions/hyprland-uwsm.desktop.disabled
sudo sed -i 's/^Name=.*/Name=Hyprland/' /usr/share/wayland-sessions/garuda-hyprland-uwsm.desktop

echo "/etc/sddm.conf file created."

# Wait 2 sec before clear so user knows what happened
sleep 2
