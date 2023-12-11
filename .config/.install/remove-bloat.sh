#!/bin/bash

cat <<"EOF"
 _     _             _   
| |__ | | ___   __ _| |_ 
| '_ \| |/ _ \ / _` | __|
| |_) | | (_) | (_| | |_ 
|_.__/|_|\___/ \__,_|\__|
EOF

# Remove bloat that came with distro installation
distro_bloat=(
    b43-fwcutter
    iwd
    octopi
    bash-completion
    libvdcss
    mlocate
    alsa-firmware
    alsa-plugins
    alsa-utils
    pavucontrol
    nano-syntax-highlighting
    vi
    micro
    nano
    fastfetch
    sddm
    linux
    linux-headers
    garuda-fish-config
    fish-autopair
    fisher
    fish-pure-prompt
    fish
    gnu-netcat
    garuda-zsh-config
    garuda-starship-prompt
    garuda-bash-config
    garuda-welcome
    garuda-gamer
    oh-my-zsh-git
    exa
    alacritty
    micro
    btop
    xdg-desktop-portal-gnome
    xdg-desktop-portal-gtk
    xdg-desktop-portal-wlr
)

read -p "Do you want to remove bloat packages? (y/n): " choice
if [ "$choice" == "y" ]; then
    for package in "${distro_bloat[@]}"; do
        if pacman -Qs "$package" > /dev/null 2>&1; then
            echo "Removing $package..."
            sudo pacman -Rsn --noconfirm "$package"
        else
            echo "$package is not installed."
        fi
    done
else
    echo "Bloat removal skipped."
fi
