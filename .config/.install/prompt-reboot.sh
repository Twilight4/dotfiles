#!/bin/bash

clear
cat <<"EOF"
 ____      _                 _   
|  _ \ ___| |__   ___   ___ | |_ 
| |_) / _ \ '_ \ / _ \ / _ \| __|
|  _ <  __/ |_) | (_) | (_) | |_ 
|_| \_\___|_.__/ \___/ \___/ \__|

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

# Prompt the user to reboot
echo "Installation Finished. Please reboot your system."
echo ""
echo "To load Zsh you need tu run this command after reboot:"
echo "  echo \"export ZDOTDIR=\"\$HOME\"/.config/zsh\" | sudo tee /etc/zsh/zshenv"
echo ""
echo "NOTE: After loading Zsh you will need to reboot once again to load Hyprland colors."
echo ""
read -p "Reboot the system? (y/n): " reboot_response

if [[ "$reboot_response" == "y" ]]; then
    echo "Rebooting the system..."
    sudo reboot
else
    echo "Reboot cancelled by user."
fi
