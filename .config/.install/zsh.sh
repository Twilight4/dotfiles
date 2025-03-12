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
read -p "This will set the default shell to Zsh. Press any key to continue or Ctrl+C to exit..." -n 1 -s
echo

# Zsh as default shell
default_shell=$(getent passwd "$(whoami)" | cut -d: -f7)
if [ "$default_shell" != "$(which zsh)" ]; then
  echo "export ZDOTDIR="$HOME"/.config/zsh" | sudo tee /etc/zsh/zshenv
	sudo chsh -s "$(which zsh)" "$(whoami)"
else
  echo
	echo "Zsh is already the default shell."
fi

# Wait 2 sec before clear so user knows what happened
sleep 2
