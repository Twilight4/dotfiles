#!/bin/bash

# Install Paru if not installed
if ! command -v paru &> /dev/null ; then
    echo "Paru is already installed."
else
    echo "Installing paru..."
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
echo ""
