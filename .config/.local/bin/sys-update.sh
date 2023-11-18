#!bin/bash

cat <<"EOF"
 _   _           _       _            
| | | |_ __   __| | __ _| |_ ___  ___ 
| | | | '_ \ / _` |/ _` | __/ _ \/ __|
| |_| | |_) | (_| | (_| | ||  __/\__ \
 \___/| .__/ \__,_|\__,_|\__\___||___/
      |_|                             

EOF

while true; do
    read -p "DO YOU WANT TO START THE UPDATE NOW? (Yy/Nn): " yn
    case $yn in
        [Yy]* )
			notify-send -u low -t 4000 -i "$HOME/.config/mako/icons/update.png" "Updating system..." 
            sudo pacman --noconfirm -Syu
			echo Done - Press enter to exit; read _
			notify-send "Update completed"
        break;;
        [Nn]* ) 
            exit;
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done
