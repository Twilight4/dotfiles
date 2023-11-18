#!/bin/bash

read -p "Do you want to install Paru? (y/n): " choice
if [ "$choice" == "y" ]; then
    if command -v paru &> /dev/null ; then
        echo "Paru is already installed."
    else
        echo "Installing Paru..."
        _installPackagesPacman "base-devel"
        SCRIPT=$(realpath "$0")
        echo $temp_path
        git clone https://aur.archlinux.org/paru-bin.git
        cd paru-bin
        makepkg --noconfirm -si
        cd -
        rm -rf paru-bin
        echo "Paru has been installed successfully."
    fi
else
    echo "Paru installation skipped."
fi
echo ""
