#!/bin/bash

clear
cat <<"EOF"
 _____    _       ____  _          _ _ 
|__  /___| |__   / ___|| |__   ___| | |
  / // __| '_ \  \___ \| '_ \ / _ \ | |
 / /_\__ \ | | |  ___) | | | |  __/ | |
/____|___/_| |_| |____/|_| |_|\___|_|_|

EOF

# Prompt the user
read -p "Do you want to change shell to Zsh? (y/n): " response

if [[ "$response" != "y" ]]; then
    echo "Operation cancelled by the user."
    exit 0
fi

# Zsh as default shell
default_shell=$(getent passwd "$(whoami)" | cut -d: -f7)
if [ "$default_shell" != "$(which zsh)" ]; then
	sudo chsh -s "$(which zsh)" "$(whoami)"
else
  echo
	echo "Zsh is already the default shell."
fi

# Export default PATH to zsh config
line_to_append='export ZDOTDIR="$HOME"/.config/zsh'

if [ -f "$zshenv_file" ]; then
	echo "Creating $zshenv_file..."
  sudo mkdir -pv /etc/zsh/zshenv
	echo "$line_to_append" | sudo tee -a /etc/zsh/zshenv
	echo "ZDOTDIR PATH added to zshenv file."
else
	echo "Error. Something went wrong."
fi

# Rebuild bat cache
bat cache --build

# Wait 2 sec before clear so user knows what happened
sleep 2
