#!/bin/bash

# Post-install message
echo "DONE, Please logout and reboot your system."
echo "------------------------------ AFTER REBOOT ------------------------------"
echo "1. Check Default Network for virt-manager status"
echo "    sudo virsh net-list --all"
echo "2. Install more packages:"
echo '    sudo npm install git-file-downloader cli-fireplace git-stats'
echo "3. Check if profile sync daemon is running:"
echo '    psd p'
echo "4. Set up browser settings"
echo "5. Customize GRUB to disable useless options:"
echo '    GRUB_DISABLE_RECOVERY=true'
echo '    GRUB_DISABLE_SUBMENU=y'
echo '    grubup'
echo "6. Import the ~/.config/superProductivity/config.json in: Settings > Sync & Export > Import From File"
echo "7. Add pub key to github: Settings > SSH > New:"
echo '    ssh-keygen -t ed25519 -C "your_email@example.com"'
echo "8. Clone relevant repos via SSH:"
echo '    git clone --depth 1 git@github.com:Twilight4/dotfiles.git ~/desktop/workspace/dotfiles'
echo '    git clone --depth 1 git@github.com:Twilight4/org.git ~/documents/org'
echo ""
