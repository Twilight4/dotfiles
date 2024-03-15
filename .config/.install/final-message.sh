#!/bin/bash

# Post-install message
echo "DONE, Please logout and reboot your system."
echo "------------------------------ AFTER REBOOT ------------------------------"
echo "1. Check Default Network for virt-manager status"
echo "    sudo virsh net-list --all"
echo "2. Install more packages:"
echo '    sudo npm install git-file-downloader git-stats'
echo "3. Check if profile sync daemon is running:"
echo '    psd p'
echo "4. Configure browser settings"
echo "5. Import the ~/.config/superProductivity/config.json in: Settings > Sync & Export > Import From File"
echo "6. Add pub key to github: Settings > SSH > New:"
echo '    ssh-keygen -t ed25519'
echo "7. Clone relevant repos via SSH:"
echo '    git clone --depth 1 git@github.com:Twilight4/dotfiles.git ~/desktop/workspace/dotfiles'
echo '    git clone --depth 1 git@github.com:Twilight4/org.git ~/documents/org'
echo "8. Set waybar and pywal theme:"
echo "    SUPER+ALT+B"
echo "    SUPER+CTRL+T - M4LW Blur Colored"
echo ""
