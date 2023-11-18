#!bin/bash

cat <<"EOF"
_ __  _ __  _ __  
| '_ \| '_ \| '_ \ 
| | | | | | | | | |
|_| |_|_| |_|_| |_|
EOF

read -p "Do you want to install plugins for nnn file manager? (y/n): " install_choice

if [[ "$install_choice" =~ ^[Yy]$ ]]; then
    if command -v nnn >/dev/null; then
	    # Installing nnn
		echo "Installing nnn cli file manager..."
		_installPackagesParu nnn-nerd

        # Installing plugins for nnn file manager if not installed
        echo "Installing plugins for nnn file manager..."
        plugins_dir="$HOME/.config/nnn/plugins"

        if [ -z "$(ls -A "$plugins_dir")" ]; then
            echo "Fetching nnn plugins..."

            sh -c "$(curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs)"

            echo "Plugins for nnn file manager installed successfully."
        else
            echo "nnn plugins directory is not empty."
        fi
    else
        echo "nnn is not installed."
    fi
else
    echo "Installation of nnn plugins canceled by user."
fi
