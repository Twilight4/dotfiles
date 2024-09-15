#!/bin/bash

clear
cat <<"EOF"
 ____   ___  _   _ _____   _ 
|  _ \ / _ \| \ | | ____  | |
| | | | | | |  \| |  _|   | |
| |_| | |_| | |\  | |___  |_|
|____/ \___/|_| \_|_____  (_)

EOF

# Clean up
if [[ -d "$HOME/dotfiles" ]]; then
    cd ~/
    echo "Cleaning up dotfiles directory..."
    rm -rf "$HOME/dotfiles"
    echo "Dotfiles directory cleaned up."
else
    echo "Error: Dotfiles directory at $HOME/dotfiles not found."
fi

# Instructions for a user
echo ""
echo "Installation Finished."
echo "Launch Hyprland with command 'Hyprland' and reboot again to complete the setup."
echo ""
