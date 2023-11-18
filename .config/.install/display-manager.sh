#!bin/bash

if [ $disman == 1 ]; then
cat <<"EOF"
____  _           _               __  __                                   
|  _ \(_)___ _ __ | | __ _ _   _  |  \/  | __ _ _ __   __ _  __ _  ___ _ __ 
| | | | / __| '_ \| |/ _` | | | | | |\/| |/ _` | '_ \ / _` |/ _` |/ _ \ '__|
| |_| | \__ \ |_) | | (_| | |_| | | |  | | (_| | | | | (_| | (_| |  __/ |   
|____/|_|___/ .__/|_|\__,_|\__, | |_|  |_|\__,_|_| |_|\__,_|\__, |\___|_|   
            |_|            |___/                            |___/
EOF

    while true; do
        read -p "Do you want to install SDDM display manager (Yy/Nn): " yn
        case $yn in
            [Yy]* )
				_installPackagesParu sddm-git
				_installPackagesParu sddm-theme-astronaut

				echo "Creating /etc/sddm.conf file..."

				echo "# Use autologin if have problems with sddm
    			#[Autologin]
    			#Session=hyprland
    			#User=twilight

    			[Theme]
    			Current=astronaut
    			CursorSize=24
				CursorTheme=Bibata-Modern-Classic
    			Font=JetBrainsMonoNerdFont
    			ThemeDir=/usr/share/sddm/themes" | sudo tee /etc/sddm.conf > /dev/null

				echo "/etc/sddm.conf file created."
            break;;
            [Nn]* ) 
                echo "SDDM setup skipped."
            break;;
            * ) echo "Please answer yes or no.";;
        esac
    done
    echo ""
fi
