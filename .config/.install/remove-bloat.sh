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
#!/usr/bin/env bash

# Remove garuda bloat if garuda linux was installed on the system
bloat=(
    garuda-dracut-support
    garuda-browser-settings
    garuda-setup-assistant
    #garuda-common-settings
    #garuda-system-maintenance
    #garuda-boot-options
    #garuda-network-assistant
    #mhwd-garuda-git
    #garuda-assistant
    garuda-icons
    garuda-gamer
    #grub-theme-garuda
    #garuda-settings-manager
    garuda-hyprland-settings
    garuda-wallpapers
    garuda-wallpapers-extra
    garuda-fish-config
    garuda-zsh-config
    garuda-starship-prompt
    garuda-bash-config
    garuda-welcome
    # Other bloat that can come with distro installation
    adobe-source-han-sans-cn-fonts
    adobe-source-han-sans-jp-fonts
    adobe-source-han-sans-kr-fonts
    alsa-utils
    archlinux-themes-sddm
    armcord-git
    asciinema
    bash-completion
    blesh-git
    bless
    broadcom-wl-dkms
    bashtop
    dialog
    edex-ui-bin
    edk2-shell
    eog
    espeakup
    flameshot
    gparted
    grub-customizer
    hexedit
    lvm2
    most
    myman
    nautilus
    nbd
    netctl
    nss-mdns
    octopi
    orca
    os-prober
    sl
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
    fish-autopair
    fisher
    fish-pure-prompt
    fish
    gnu-netcat
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
