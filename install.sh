#!/usr/bin/env bash

# This script assumes that I used my personal alis installation script with install-tweaks.sh beforewards
run() {
    update-system
    download-paclist
    download-yaylist
    install-yay
    install-apps
    create-directories
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
    # remove useless packages installed by alis
    sudo pacman -Rns sddm linux linux-headers
    # without flag --noconfirm to choose from which provider to install certain packages
    sudo pacman -S "$(cat /tmp/paclist)"
    yay -S "$(cat /tmp/yaylist)"
    
    # plugins for nnn file manager
    sh -c "$(curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs)"
    
    # these apps are unavailable in arch repos
    sudo curl -L https://github.com/arcolinux/arcolinux_repo/raw/main/x86_64/archlinux-logout-git-23.01-01-any.pkg.tar.zst -O /tmp/archlinux-logout-git-23.01-01-any.pkg.tar.zst
    sudo pacman -U --noconfirm --needed /tmp/archlinux-logout-git-23.01-01-any.pkg.tar.zst
    
    # gaming on linux
    #sudo pacman --noconfirm -S lutris
    #sudo pacman --noconfirm -S --needed lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader
    #sudo pacman --noconfirm -S --needed wine-staging giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls \
    #mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error \
    #lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo \
    #sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama \
    #ncurses lib32-ncurses ocl-icd lib32-ocl-icd libxslt lib32-libxslt libva lib32-libva gtk3 \
    #lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader
    
    # zsh as default terminal for user
    sudo chsh -s "$(which zsh)" "$(whoami)"
    
    # for razer gears
    sudo groupadd plugdev
    sudo gpasswd -a "$(whoami)" plugdev
    
    # mpd group
    sudo gpasswd -a "$(whoami)" mpd
    sudo chmod 710 "/home/$(whoami)"
    
    # audit group
    sudo groupadd -r audit
    sudo gpasswd -a "$(whoami)" audit
    
    # autologin group for sddm
    sudo groupadd autologin
    sudo gpasswd -a "$(whoami)" autologin
      
    ## for Docker
    #gpasswd -a "$name" docker
    #usermod -aG docker $(whoami)
    #sudo systemctl enable docker.service
}

create-directories() {
sudo mkdir -p "/home/$(whoami)/{documents,desktop,downloads,videos,workspace,music,pictures}"
}

install-dotfiles() {
    DOTFILES="/tmp/dotfiles"
    if [ ! -d "$DOTFILES" ]
        then
            git clone --recurse-submodules "https://github.com/Twilight4/dotfiles" "$DOTFILES" >/dev/null
    fi
    
    LOGSEQ="~/documents/logseq-notes"
    if [ ! -d "$LOGSEQ" ]
        then
            git clone --recurse-submodules "https://github.com/Twilight4/logseq-notes" "$DOTFILES" >/dev/null
    fi
    
    # Prevent permission denied errors
    sudo rm -rf ~/go
    sudo mv -u /tmp/dotfiles/.config/* "$HOME/.config"
    source "/home/$(whoami)/.config/zsh/.zshenv"
    sudo rm -rf /usr/share/fonts
    sudo mv /tmp/dotfiles/.config/.local/share/fonts ~/.config/.local/share
    sudo rm "/home/$(whoami)/.config/.local/share/fonts/README.md"
    sudo fc-cache -fv
    sudo rm /home/"$(whoami)"/.bash*
    sudo mkdir -p ~/.config/.local/share/mpd/playlists
    sudo chmod 755 "$XDG_CONFIG_HOME"/hypr/scripts/*
    sudo rm -rf /usr/share/sddm/themes/aerial/playlists
    sudo chmod 755 "$XDG_CONFIG_HOME"/waybar/scripts/*
    sudo chmod 755 "$HOME"/.config/rofi/applets/bin/*
    sudo chmod 755 "$XDG_CONFIG_HOME"/rofi/applets/shared/theme.bash
    sudo chmod 755 "$XDG_CONFIG_HOME"/rofi/launcher/launcher.sh
    sudo chmod 755 "$XDG_CONFIG_HOME"/rofi/wifi/wifi
    sudo chmod 755 "$XDG_CONFIG_HOME"/rofi/applets/bin/*
    sudo chmod 755 "$XDG_CONFIG_HOME"/zsh/bash-scripts/*.sh
    sudo chmod 755 /opt/logseq-desktop
    
    # system services
    playerctld daemon                                                                 # if it doesn't work try installing volumectl
    systemctl --user enable greenclip.service                                         # enable cliphistory daemon
    systemctl --user enable mpd.service                                               # mpd daemon
    systemctl --user enable psd.service                                               # profile sync daemon
    sudo systemctl enable vnstat.service                                              # network traffic monitor
    sudo systemctl enable ananicy.service                                             # enable ananicy daemon 
    sudo systemctl enable nohang-desktop.service                                      # enable nohang daemon
    sudo systemctl enable paccache.timer                                              # enable weekly pkg cache cleaning
    sudo systemctl status libvirtd.service                                            # enable qemu/virt manager daemon
    # enable performance and security tweaks
    sudo systemctl enable sddm
    sudo systemctl enable auditd
    sudo systemctl enable apparmor
    sudo systemctl enable firewalld
    sudo systemctl enable irqbalance
    sudo systemctl enable chronyd
    # change the ownership of mpd directory
    sudo chown -R twilight:twilight ~/.config/.local
    
# Hyprland desktop entry
#sudo mv /tmp/dotfiles/hyprland.desktop /usr/share/wayland-sessions/hyprland.desktop
sudo bash -c 'cat > /usr/share/wayland-sessions/hyprland.desktop' <<-'EOF'
[Desktop Entry]
Name=Hyprland
Comment=hyprland
Exec="$HOME/.config/hypr/scripts/starth"
Type=Application
EOF

# SDDM rice
sudo bash -c 'cat > /etc/sddm.conf' <<-'EOF'
# Use autologin if have problems with sddm
#[Autologin]
#Session=hyprland
#User=twilight

[Theme]
Current=aerial
CursorSize=24
CursorTheme=Numix-Cursor-Light
Font=JetBrains Mono
ThemeDir=/usr/share/sddm/themes
EOF

# Grub rice
git clone https://github.com/HenriqueLopes42/themeGrub.CyberEXS
mv themeGrub.CyberEXS CyberEXS
sudo mv CyberEXS /boot/grub/themes/
    
# tmux plugin manager
[ ! -d "$XDG_CONFIG_HOME/tmux/plugins/tpm" ] \
&& git clone --depth 1 https://github.com/tmux-plugins/tpm \
"$XDG_CONFIG_HOME/tmux/plugins/tpm"

echo 'Post-Installation:
- NOW ISSUE THIS COMMAND AS ROOT: echo 'export ZDOTDIR="$HOME"/.config/zsh' > /etc/zsh/zshenv
- to finish GRUB rice as root user by issue commands:
sudo echo 'GRUB_THEME=/boot/grub/themes/CyberEXS/theme.txt' >> /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
- setup logseq git sync
- sshcreate <name> - Add pub key to github: Settings > SSH > New
-- reload tmux plugin manager: ctrl + a + shift + i and hit q
- to check if profile sync daemon is running type command: psd p
- these needs to be installed after shell is changed to zsh: sudo npm install git-file-downloader cli-fireplace git-stats
- after reboot you can refresh/fix keyrings with: SUPER + SHIFT + U
- you can now reboot: systemctl reboot -i'
}

run "$@"
