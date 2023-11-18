#!bin/bash

# Post-install message
echo "DONE, Please logout and reboot your system."
echo "------------------------------ AFTER REBOOT ------------------------------"
echo "Check if AMD P-State Preferred Core Handling is enabled with following command"
echo '    cat /sys/devices/system/cpu/amd_pstate/prefcore'
echo "Start Default Network for virt-manager:"
echo '    sudo virsh net-start default'
echo '    sudo virsh net-autostart default'
echo "    Check status with: sudo virsh net-list --all"
echo "Install more packages:"
echo '    sudo npm install git-file-downloader cli-fireplace git-stats'
echo "Check if profile sync daemon is running:"
echo '    psd p'
echo "Uncomment last 2 lines in kitty.conf"
echo "Add pub key to github: Settings > SSH > New:"
echo '    ssh-keygen -t ed25519 -C "your_email@example.com"'
echo "Clone relevant repos via SSH:"
echo '    git clone git@github.com:Twilight4/dotfiles.git ~/desktop/workspace/dotfiles'
echo '    git clone git@github.com:Twilight4/cheats.git ~/desktop/workspace/cheats'
echo '    git clone git@github.com:Twilight4/emacs-notes.git ~/documents/org'
echo '    git clone git@github.com:Twilight4/firefox-config.git ~/.mozilla'
echo ""
