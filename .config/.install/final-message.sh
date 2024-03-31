#!/bin/bash

# Post-install message
echo "DONE, Please logout and reboot your system."
echo "------------------------------ AFTER REBOOT ------------------------------"
echo "1. Check Default Network for virt-manager status"
echo "    sudo virsh net-list --all"
echo "2. Check if profile sync daemon is running:"
echo '    psd p'
echo "3. Configure browser settings"
echo "4. Import the ~/.config/superProductivity/config.json in: Settings > Sync & Export > Import From File"
echo "5. Add pub key to github: Settings > SSH > New:"
echo '    ssh-keygen -t ed25519'
echo "6. Clone relevant repos via SSH:"
echo '    git clone --depth 1 git@github.com:Twilight4/dotfiles.git ~/desktop/workspace/dotfiles'
echo '    git clone --depth 1 git@github.com:Twilight4/org.git ~/documents/org'
echo '    git clone --depth 1 git@github.com:Twilight4/cheats.git ~/.config/cheat'
echo '7. Copy my org notes to cheat directory using "cptocht" alias command'
echo "8. Install more tools from arch-setup/tools-installation directory"
echo "9. If the waybar workspaces icons are not in proper sequence, in modules.json change the numbers temporarily and restart waybar again, they will flal in place"
echo ""
