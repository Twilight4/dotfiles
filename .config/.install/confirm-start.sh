#!bin/bash

SCRIPT=$(realpath "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
if [ $SCRIPTPATH = "/home/$USER/.config" ]; then
    echo "IMPORTANT: You're running the installation script from the installation target directory."
    echo "Please move the dotfiles repository to i.e. ~/downloads/ and start the script again."
    echo ""
    if [ ! $mode == "dev" ]; then
        exit
    fi
fi

while true; do
    read -p "DO YOU WANT TO START THE INSTALLATION NOW? (Yy/Nn): " yn
    case $yn in
        [Yy]* )
            echo "Installation started."
        break;;
        [Nn]* ) 
            echo "Installation canceled."
            exit;
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done
echo ""
