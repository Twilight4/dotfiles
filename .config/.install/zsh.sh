#!/bin/bash

cat <<"EOF"
 _____    _       ____  _          _ _ 
|__  /___| |__   / ___|| |__   ___| | |
  / // __| '_ \  \___ \| '_ \ / _ \ | |
 / /_\__ \ | | |  ___) | | | |  __/ | |
/____|___/_| |_| |____/|_| |_|\___|_|_|

EOF

# Prompt the user
read -p "Do you want to change shel to Zsh? (y/n): " response

if [[ "$response" != "y" ]]; then
    echo "Operation cancelled by the user."
    exit 0
fi

# Zsh as default shell
default_shell=$(getent passwd "$(whoami)" | cut -d: -f7)
if [ "$default_shell" != "$(which zsh)" ]; then
	echo "Changing shell to Zsh..."
	sudo chsh -s "$(which zsh)" "$(whoami)"
	echo "Shell changed to Zsh."
else
	echo "Zsh is already the default shell."
fi

# Export default PATH to zsh config
zshenv_file="/etc/zsh/zshenv"
line_to_append='export ZDOTDIR="$HOME"/.config/zsh'

if [ -f "$zshenv_file" ]; then
	echo "Creating $zshenv_file..."
	sudo echo "$line_to_append" | sudo tee -a "$zshenv_file"
	echo "ZDOTDIR PATH added to zshenv file."
  source ~/.config/zsh/.zshrc
else
	echo "Error. Something went wrong."
fi

# Installing NVChad
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
