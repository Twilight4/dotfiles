#!bin/bash

cat <<"EOF"
               _                     _       _                 _   
 ___ _   _ ___| |_ ___ _ __ ___   __| |     | |__   ___   ___ | |_ 
/ __| | | / __| __/ _ \ '_ ` _ \ / _` |_____| '_ \ / _ \ / _ \| __|
\__ \ |_| \__ \ ||  __/ | | | | | (_| |_____| |_) | (_) | (_) | |_ 
|___/\__, |___/\__\___|_| |_| |_|\__,_|     |_.__/ \___/ \___/ \__|
     |___/                                                         
EOF

read -p "Do you want to disable systemd-boot startup entry? (y/n): " disable_choice

if [[ "$disable_choice" =~ ^[Yy]$ ]]; then
    if [ -d "/sys/firmware/efi/efivars" ] && [ -d "/boot/loader" ]; then
        echo "Disabling systemd-boot startup entry"
        sudo sed -i 's/^timeout/# timeout/' /boot/loader/loader.conf
        echo "Disabled systemd-boot startup entry"
    else
        echo "systemd-boot is not being used."
    fi
else
    echo "Disabling systemd-boot startup entry canceled by user."
fi
