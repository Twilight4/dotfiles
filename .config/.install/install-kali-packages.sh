#!/bin/bash

# Install base packages
sudo apt install libayatana-appindicator3-1 gir1.2-ayatanaappindicator3-0.1 lsd swaybg wdisplays ripgrep silversearcher-ag irqbalance acpi emacs profile-sync-daemon dunst translate-shell duf speedtest-cli gnome-weather gnome-keyring cpufetch fd-find trash-cli linux-cpupower mingw-w64 zathura grc poppler-utils gnome-maps wf-recorder thefuck libsecret-tools chafa alsa-utils pipewire pipewire-alsa pipewire-audio pipewire-jack pipewire-pulse wireplumber gtk2-engines-murrine freerdp2-wayland proxychains
sudo pip3 install pywal pyftpdlib
sudo apt purge sway-notification-center fdclone chromium
