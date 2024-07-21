#!/bin/bash

clear

# Clean up
if [[ -d "$HOME/dotfiles" ]]; then
    cd ~/
    echo "Cleaning up dotfiles directory..."
    rm -rf "$HOME/dotfiles"
    echo "Dotfiles directory cleaned up."
else
    echo "Error: Dotfiles directory at $HOME/dotfiles not found."
fi

# Prompt the user to reboot
echo "Installation Finished. Please reboot your system."
echo ""
read -p "Reboot the system? (y/n): " reboot_response

if [[ "$reboot_response" == "y" ]]; then
    echo "Rebooting the system..."
    sudo reboot
else
    echo "Reboot cancelled by user."
fi
