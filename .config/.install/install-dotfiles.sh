#!bin/bash

cat <<"EOF"
 ___           _        _ _       _       _    __ _ _           
|_ _|_ __  ___| |_ __ _| | |   __| | ___ | |_ / _(_) | ___  ___ 
 | || '_ \/ __| __/ _` | | |  / _` |/ _ \| __| |_| | |/ _ \/ __|
 | || | | \__ \ || (_| | | | | (_| | (_) | |_|  _| | |  __/\__ \
|___|_| |_|___/\__\__,_|_|_|  \__,_|\___/ \__|_| |_|_|\___||___/
                                                                

EOF
echo "The script will now remove existing directories and files from ~/.config/"
echo "and copy your prepared configuration from ~/downloads/dotfiles/ to ~/desktop/workspace/dotfiles"
echo "Symbolic links will then be created from ~/desktop/workspace/dotfiles into your ~/.config/ directory."
echo ""

while true; do
    read -p "Do you want to install the dotfiles now? (Yy/Nn): " yn
    case $yn in
        [Yy]* )
            if [ ! $mode == "dev" ]; then
                echo "Copying dotfiles..."
                if [ ! -d ~/desktop/workspace/dotfiles ]; then
                    mkdir -p ~/desktop/workspace/dotfiles
                fi   
                cp -rf ~/downloads/dotfiles ~/desktop/workspace/dotfiles/
                echo "Dotfiles copied successfully."
            else
                echo "Skipped: DEV MODE!"
            fi
        break;;
        [Nn]* ) 
            exit
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done
echo ""
