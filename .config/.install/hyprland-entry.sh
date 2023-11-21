#!/bin/bash

read -p "Do you want to create a Hyprland desktop entry? (y/n): " create_entry_choice

if [[ "$create_entry_choice" =~ ^[Yy]$ ]]; then
    if command -v Hyprland >/dev/null; then
        echo "Creating Hyprland desktop entry..."

		curl -LJO https://raw.githubusercontent.com/Twilight4/arch-setup/main/config-files/hyprland.desktop && sudo mv hyprland.desktop /usr/share/wayland-sessions/

        echo "Hyprland desktop entry created."
    else
        echo "Hyprland is not installed."
    fi
else
    echo "Creation of Hyprland desktop entry canceled by user."
fi
