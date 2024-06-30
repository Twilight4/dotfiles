#!/bin/bash

clear
cat <<"EOF"
 _   ___     ______ _               _ 
| \ | \ \   / / ___| |__   __ _  __| |
|  \| |\ \ / / |   | '_ \ / _` |/ _` |
| |\  | \ V /| |___| | | | (_| | (_| |
|_| \_|  \_/  \____|_| |_|\__,_|\__,_|

EOF

# Prompt user for input
read -p "Do you want to install NVChad configuration (y/n)? " answer

# Validate user input
if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
    echo "Operation cancelled by the user."
    exit 0
fi

# Remove existing NVChad configuration if it exists
if [[ -d "$HOME/.config/nvim" ]]; then
    rm -rf "$HOME/.config/nvim"
    echo "Existing NVChad configuration removed."
fi

# Clone the NVChad repository
if git clone https://github.com/NvChad/starter "$HOME/.config/nvim"; then
    echo "NVChad configuration cloned successfully."
else
    echo "Failed to clone NVChad repository."
    exit 1
fi

# Copy custom lua file
cp "$HOME/dotfiles/.config/nvim/lua/kitty+page.lua" "$HOME/.config/nvim/lua" && \
echo "Custom lua file copied successfully."

# End of script
echo "NVChad configuration installation complete."
