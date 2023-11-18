#!bin/bash

cat <<"EOF"
 ___           _        _ _                    _                         
|_ _|_ __  ___| |_ __ _| | |  _ __   __ _  ___| | ____ _  __ _  ___  ___ 
 | || '_ \/ __| __/ _` | | | | '_ \ / _` |/ __| |/ / _` |/ _` |/ _ \/ __|
 | || | | \__ \ || (_| | | | | |_) | (_| | (__|   < (_| | (_| |  __/\__ \
|___|_| |_|___/\__\__,_|_|_| | .__/ \__,_|\___|_|\_\__,_|\__, |\___||___/
                             |_|                         |___/           
EOF

# If first time building rust packages this needs to be set
rustup default stable

_installPackagesPacman "${packagesPacman[@]}";
_installPackagesParu "${packagesParu[@]}";

read -p "Do you want to proceed with the installation of non-essential packages? (y/n): " choice
if [ "$choice" == "y" ]; then
    _installPackagesPacman "${nonessentialpackagesPacman[@]}"
    _installPackagesParu "${nonessentialpackagesParu[@]}"
else
    echo "Installation of non-essential packages skipped."
fi
echo ""
