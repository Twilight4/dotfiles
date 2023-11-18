#!/bin/bash

cat <<"EOF"
 _     _             _   
| |__ | | ___   __ _| |_ 
| '_ \| |/ _ \ / _` | __|
| |_) | | (_) | (_| | |_ 
|_.__/|_|\___/ \__,_|\__|
EOF

# Remove bloat that came with distro installation
cachyos_bloat=(
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
    cachyos-fish-config
    fish-autopair
    fisher
    fish-pure-prompt
    fish
    cachyos-zsh-config
    oh-my-zsh-git
    cachyos-hello
    cachyos-kernel-manager
    exa
    alacritty
    micro
    cachyos-micro-settings
    btop
    cachyos-packageinstaller
    xdg-desktop-portal-gnome
    xdg-desktop-portal-gtk
    xdg-desktop-portal-wlr
    lib32-opencl-clover-mesa
    lib32-opencl-rusticl-mesa
)

read -p "Do you want to remove bloat packages? (y/n): " choice
if [ "$choice" == "y" ]; then
    for package in "${cachyos_bloat[@]}"; do
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
