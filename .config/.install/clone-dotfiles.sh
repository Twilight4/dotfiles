#!/bin/bash

cat <<"EOF"
      _                        _       _    __ _ _           
  ___| | ___  _ __   ___    __| | ___ | |_ / _(_) | ___  ___ 
 / __| |/ _ \| '_ \ / _ \  / _` |/ _ \| __| |_| | |/ _ \/ __|
| (__| | (_) | | | |  __/ | (_| | (_) | |_|  _| | |  __/\__ \
 \___|_|\___/|_| |_|\___|  \__,_|\___/ \__|_| |_|_|\___||___/

EOF

while true; do
	read -p "Do you want to install the dotfiles now? (Yy/Nn): " yn
	case $yn in
	[Yy]*)
		if [ ! $mode == "dev" ]; then
			echo "Cloning dotfiles..."
			git clone --depth 1 https://github.com/Twilight4/dotfiles ~/downloads/dotfiles
			echo "Dotfiles cloned successfully."
		else
			echo "Skipped: DEV MODE!"
		fi
		break
		;;
	[Nn]*)
		exit
		break
		;;
	*) echo "Please answer yes or no." ;;
	esac
done
echo ""
