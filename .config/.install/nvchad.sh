#!/bin/bash

clear
cat <<"EOF"
 _   ___     ______ _               _ 
| \ | \ \   / / ___| |__   __ _  __| |
|  \| |\ \ / / |   | '_ \ / _` |/ _` |
| |\  | \ V /| |___| | | | (_| | (_| |
|_| \_|  \_/  \____|_| |_|\__,_|\__,_|

EOF

# Prompt the user
read -p "This will install NVChad configuration. Press any key to continue or Ctrl+C to exit..." -n 1 -s
echo

# Remove existing NVChad configuration if it exists
if [[ -d "$HOME/.config/nvim" ]]; then
    echo
    rm -rvf "$HOME/.config/nvim"
    rm -rf ~/.config/nvim
    rm -rf ~/.local/state/nvim
    rm -rf ~/.local/share/nvim
    echo "Existing NVChad configuration removed."
fi

# Clone the NVChad repository
if git clone https://github.com/NvChad/starter "$HOME/.config/nvim"; then
    echo "NVChad configuration cloned successfully."

    # Set background color to the same as in kitty and emacs
    echo -e "\n-- Disable the status line\nvim.opt.laststatus = 0\n\n-- set background color to #040305\nvim.cmd(\"highlight Normal guibg=#040305 ctermbg=black\")" >> ~/.config/nvim/init.lua
else
    echo "Failed to clone NVChad repository."
    exit 1
fi

# Copy custom lua file
cp "$HOME/dotfiles/.config/nvim/lua/kitty+page.lua" "$HOME/.config/nvim/lua" && \
echo
echo "Custom lua file copied successfully."

# End of script
echo "NVChad configuration installation complete."

# Wait 2 sec before clear so user knows what happened
sleep 2
