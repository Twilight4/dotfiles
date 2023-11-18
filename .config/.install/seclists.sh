#!bin/bash

cat <<"EOF"
 ____            _     _     _       
/ ___|  ___  ___| |   (_)___| |_ ___ 
\___ \ / _ \/ __| |   | / __| __/ __|
 ___) |  __/ (__| |___| \__ \ |_\__ \
|____/ \___|\___|_____|_|___/\__|___/
EOF
                                     
payloads_dir="/usr/share/payloads"
seclists_dir="$payloads_dir/SecLists"

if [ ! -d "$payloads_dir" ] || [ ! -d "$seclists_dir" ]; then

    # Prompt user to clone SecLists cuz it's over 1GB
    echo "SecLists repository is over 1GB in size. Cloning it may take a considerable amount of time and disk space."
    read -p "Do you want to proceed with cloning SecLists? (y/n): " choice

    if [ "$choice" == "y" ] || [ "$choice" == "Y" ]; then
		echo "Creating directories and cloning SecLists repository..."
        sudo mkdir -p "$payloads_dir"/SecLists
        sudo git clone --depth 1 https://github.com/danielmiessler/SecLists.git "$seclists_dir"
    else
        echo "SecLists repository installation skipped."
    fi
else
    echo "SecLists repository already exists in $seclists_dir."
fi
