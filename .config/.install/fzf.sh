#!/bin/bash

echo
cat <<"EOF"
 _____ __________ 
|  ___|__  /  ___|
| |_    / /| |_   
|  _|  / /_|  _|  
|_|   /____|_|    
                  
EOF

# Prompt user for input
read -p "Do you want to install FZF (y/n)? " answer

# Validate user input
if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
    echo "Operation cancelled by the user."
    exit 0
fi

# Clone the NVChad repository
if git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"; then
    ~/.fzf/install
    echo "FZF installed successfully."
else
    echo "Failed to install FZF."
    exit 1
fi
