#!/usr/bin/env bash
# Standalone script (not sourced by install.sh).
set -euo pipefail

cat <<"EOF"
               _                     _       _                 _
 ___ _   _ ___| |_ ___ _ __ ___   __| |     | |__   ___   ___ | |_
/ __| | | / __| __/ _ \ '_ ` _ \ / _` |_____| '_ \ / _ \ / _ \| __|
\__ \ |_| \__ \ ||  __/ | | | | | (_| |_____| |_) | (_) | (_) | |_
|___/\__, |___/\__\___|_| |_| |_|\__,_|     |_.__/ \___/ \___/ \__|
     |___/
EOF

read -rp "Do you want to disable systemd-boot startup entry? (y/n): " disable_choice

if [[ $disable_choice =~ ^[Yy]$ ]]; then
    if [[ -d /sys/firmware/efi/efivars && -d /boot/loader ]]; then
        printf "\033[34m:: %s\033[0m\n" "Disabling systemd-boot startup entry"
        sudo sed -i 's/^timeout/# timeout/' /boot/loader/loader.conf
        printf "\033[32m:: %s\033[0m\n" "Disabled systemd-boot startup entry"
    else
        printf "\033[33m%s\033[0m\n" "systemd-boot is not being used."
    fi
else
    printf "\033[33m%s\033[0m\n" "Disabling systemd-boot startup entry canceled by user."
fi
