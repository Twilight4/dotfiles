#!/bin/bash

clear
cat <<"EOF"
 _____ __________ 
|  ___|__  /  ___|
| |_    / /| |_   
|  _|  / /_|  _|  
|_|   /____|_|    
                  
EOF

# Prompt the user
read -p "This will install FZF and atuin. Press any key to continue or Ctrl+C to exit..." -n 1 -s
echo

# Check if the ~/.fzf directory exists
if [ -d "$HOME/.fzf" ]; then
    echo
    echo "~/.fzf directory already exists. Skipping..."
else
    # Clone the NVChad repository
    if git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"; then
        ~/.fzf/install
        echo
        echo "FZF installed successfully."
    else
        echo
        echo "Failed to install FZF."
        exit 1
    fi
fi

# Wait 2 sec before clear so user knows what happened
sleep 2

# Install atuin
clear
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh

# Wait 2 sec before clear so user knows what happened
sleep 2
