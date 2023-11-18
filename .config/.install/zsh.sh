#!bin/bash

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
