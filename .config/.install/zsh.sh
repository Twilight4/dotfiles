#!/bin/bash

cat <<"EOF"
 _____    _       ____  _          _ _ 
|__  /___| |__   / ___|| |__   ___| | |
  / // __| '_ \  \___ \| '_ \ / _ \ | |
 / /_\__ \ | | |  ___) | | | |  __/ | |
/____|___/_| |_| |____/|_| |_|\___|_|_|

EOF

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

if [ ! -f "$zshenv_file" ]; then
	echo "Creating $zshenv_file..."
	sudo echo "$line_to_append" | sudo tee -a "$zshenv_file"
	echo "$zshenv_file created."
else
	echo "$zshenv_file already exists."
fi

# Neovim Installation Script
# Ask user if they want to install LazyVim
read -p "Do you want to install LazyVim? (y/n): " install_lazyvim
if [[ $install_lazyvim =~ ^[Yy]$ ]]; then
	# Backup current Neovim files
	echo "Backing up current Neovim files..."
	mkdir -p ~/.config/nvim.bak
	mv ~/.config/nvim/* ~/.config/nvim.bak 2>/dev/null
	mv ~/.local/share/nvim ~/.local/share/nvim.bak 2>/dev/null
	mv ~/.local/state/nvim ~/.local/state/nvim.bak 2>/dev/null
	mv ~/.cache/nvim ~/.cache/nvim.bak 2>/dev/null

	# Clone the lazyvim starter
	echo "Cloning LazyVim starter..."
	git clone https://github.com/LazyVim/starter ~/.config/nvim

	# Remove the .git folder
	echo "Removing .git folder..."
	rm -rf ~/.config/nvim/.git

	echo "LazyVim installation completed successfully."
	echo "Make sure to run ':checkhealth' after installation for additional setup."
else
	echo "Skipping LazyVim installation."
fi
