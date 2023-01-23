#!/usr/bin/env bash

run() {
    update-system
    download-paclist
    download-yaylist
    install-yay
    install-apps
    #enable-blackarch
    #create-directories
    install-wifi-driver
    install-dotfiles
}

update-system() {
    sudo pacman --noconfirm -Syu
}

download-paclist() {
    paclist_path="/tmp/paclist" 
    curl "https://raw.githubusercontent.com/Twilight4/arch-install/master/paclist" > "$paclist_path"

    echo $paclist_path
}

download-yaylist() {
    yaylist_path="/tmp/yaylist"
    curl "https://raw.githubusercontent.com/Twilight4/arch-install/master/yaylist" > "$yaylist_path"

    echo $yaylist_path
}

install-yay() {
    sudo pacman -S --noconfirm git
    git clone https://aur.archlinux.org/yay-bin \
    && cd yay-bin \
    && makepkg --noconfirm -si \
    && cd - \
    && rm -rf yay-bin
}

install-apps() {
    yay -S --noconfirm $(cat /tmp/yaylist)
    sudo pacman -S --noconfirm $(cat /tmp/paclist)
    
    # plugins for nnn file manager
    sh -c "$(curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs)"
    
    # this app is unavailable in arch repos
    pip install github-clone
    mv ~/.local/bin/ghclone /usr/local/bin
            
    # zsh as default terminal for user
    sudo chsh -s "$(which zsh)" "$(whoami)"
    
    # for razer gears
    sudo groupadd plugdev
    sudo gpasswd -a "$(whoami)" plugdev
    
    # mpd group
    sudo gpasswd -a mpd "$(whoami)"
    sudo chmod 710 "/home/$(whoami)"
    
    # audit group
    sudo groupadd -r audit
    sudo gpasswd -a "$(whoami)" audit
      
    ## for Docker
    #gpasswd -a "$name" docker
    #usermod -aG docker $(whoami)
    #sudo systemctl enable docker.service
}

#enable-blackarch() {
    #curl -O https://blackarch.org/strap.sh
    #echo 5ea40d49ecd14c2e024deecf90605426db97ea0c strap.sh | sha1sum -c
    #chmod +x strap.sh
    #sudo ./strap.sh
    #sudo pacman --noconfirm -Syu
    #rm strap.sh
#}

#create-directories() {
#sudo mkdir -p "/home/$(whoami)/{Document,Download,Video,workspace,Music}"
#}

install-wifi-driver() {
    git clone https://github.com/Mange/rtl8192eu-linux-driver
    cd rtl8192eu-linux-driver
    sudo dkms add .
    sudo dkms install rtl8192eu/1.0
    cd -
    echo "blacklist rtl8xxxu" | sudo tee /etc/modprobe.d/rtl8xxxu.conf
    echo -e "8192eu\n\nloop" | sudo tee /etc/modules
    echo "options 8192eu rtw_power_mgnt=0 rtw_enusbss=0" | sudo tee /etc/modprobe.d/8192eu.conf
    sudo grub-mkconfig -o /boot/grub/grub.cfg
    rm -rf rtl8192eu-linux-driver
}

install-dotfiles() {
    DOTFILES="/tmp/dotfiles"
    if [ ! -d "$DOTFILES" ]
        then
            git clone --recurse-submodules "https://github.com/Twilight4/dotfiles" "$DOTFILES" >/dev/null
    fi
    
    sudo mv -u /tmp/dotfiles/.config/* "$HOME/.config"
    source "/home/$(whoami)/.config/zsh/.zshenv"
    sudo rm -rf /usr/share/fonts
    sudo rm "/home/$(whoami)/.config/.local/share/fonts/README.md"
    sudo fc-cache -fv
    sudo rm /home/$(whoami)/.bash*
    sudo mkdir -p ~/.config/.local/share/mpd
    sudo chmod 755 $XDG_CONFIG_HOME/hypr/scripts/*
    sudo chmod 755 $XDG_CONFIG_HOME/waybar/scripts/*
    sudo chmod 755 $HOME/.config/rofi/applets/bin/*
    sudo chmod 755 $XDG_CONFIG_HOME/rofi/applets/shared/theme.bash
    sudo chmod 755 $XDG_CONFIG_HOME/rofi/launcher/launcher.sh
    sudo chmod 755 $XDG_CONFIG_HOME/rofi/wifi/wifi
    sudo chmod 755 $XDG_CONFIG_HOME/zsh/bash-scripts/*.sh
    git config --global user.email "electrolight071@gmail.com"
    git config --global user.name "Twilight4"
        
    # system services
    systemctl --user enable greenclip.service                                         # enable cliphistory daemon
    systemctl --user enable mpd.service                                               # mpd daemon
    systemctl --user enable psd.service                                               # profile sync daemon
    systemctl --user enable vnstat.service                                            # network traffic monitor
    #systemctl --user enable emacs.service                                             # enable emacs server daemon
    sudo systemctl enable ananicy.service                                             # enable ananicy daemon 
    sudo systemctl enable nohang-desktop.service                                      # enable nohang daemon
    # enable performance and security tweaks
    sudo systemctl enable auditd
    sudo systemctl enable apparmor
    sudo systemctl enable firewalld
    sudo systemctl enable irqbalance
    sudo systemctl enable chronyd
    
# Hyprland desktop entry
#sudo mv /tmp/dotfiles/hyprland.desktop /usr/share/wayland-sessions/hyprland.desktop
sudo bash -c 'cat > /usr/share/wayland-sessions/hyprland.desktop' <<-'EOF'
[Desktop Entry]
Name=Hyprland
Comment=hyprland
Exec="$HOME/.config/hypr/scripts/starth"
Type=Application
EOF
    
# tmux plugin manager
[ ! -d "$XDG_CONFIG_HOME/tmux/plugins/tpm" ] \
&& git clone --depth 1 https://github.com/tmux-plugins/tpm \
"$XDG_CONFIG_HOME/tmux/plugins/tpm"

echo 'Post-Installation:
- NOW ISSUE THIS COMMAND AS ROOT: echo 'export ZDOTDIR="$HOME"/.config/zsh' > /etc/zsh/zshenv
- sshcreate <name> - Add pub key to github: Settings > SSH > New
- reload tpm: ctrl + a + shift + i and hit q
- to check if profile sync daemon is running type command: psd p
- to scan for hardware thermal sensors - configure with sensors-detect
- to check installed wifi chipset you can issue a command: sudo hwinfo --network | grep Driver
- you can now refresh/fix keyrings with: SUPER + SHIFT + U
- now you reboot: systemctl reboot -i
'
}

run "$@"
