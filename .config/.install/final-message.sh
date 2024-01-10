#!/bin/bash

# Post-install message
echo "DONE, Please logout and reboot your system."
echo "------------------------------ AFTER REBOOT ------------------------------"
echo "Check Default Network for virt-manager status"
echo "    sudo virsh net-list --all"
echo "Install more packages:"
echo '    sudo npm install git-file-downloader cli-fireplace git-stats'
echo "Check if profile sync daemon is running:"
echo '    psd p'
echo "Uncomment last 2 lines in kitty.conf"
echo "If gparted doesn't run try: xhost si:localuser:root"
echo "Import the ~/.config/superProductivity/config.json in: Settings > Sync & Export > Import From File"
echo "Add pub key to github: Settings > SSH > New:"
echo '    ssh-keygen -t ed25519 -C "your_email@example.com"'
echo "Clone relevant repos via SSH:"
echo '    git clone --depth 1 git@github.com:Twilight4/dotfiles.git ~/desktop/workspace/dotfiles'
echo '    git clone --depth 1 git@github.com:Twilight4/cheats.git ~/desktop/workspace/cheats'
echo '    git clone --depth 1 git@github.com:Twilight4/org.git ~/documents/'
echo '    git clone --depth 1 git@github.com:Twilight4/mercury-config.git ~/downloads'
echo ""
