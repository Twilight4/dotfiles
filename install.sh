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
    paclist_path="/tmp/paclist"    # Also possible paclist-stripped
    curl "https://raw.githubusercontent.com/Twilight4/arch-install/master/paclist" > "$paclist_path"

    echo $paclist_path
}

download-yaylist() {
    yaylist_path="/tmp/yaylist"    # Also possible yaylist-stripped
    curl "https://raw.githubusercontent.com/Twilight4/arch-install/master/yaylist" > "$yaylist_path"

    echo $yaylist_path
}

install-yay() {
    sudo pacman -S --noconfirm git ccache
    git clone https://aur.archlinux.org/yay-bin \
    && cd yay-bin \
    && makepkg --noconfirm -si \
    && cd - \
    && rm -rf yay-bin
}

install-apps() {
    # remove redundant packages installed by alis
    sudo pacman -Rns --noconfirm sddm linux linux-headers
    # remove redundant packages installed by cachyos
    sudo pacman -Rns --noconfirm cachyos-fish-config fish-autopair fisher fish-pure-prompt fish cachyos-zsh-config oh-my-zsh.git cachyos-hello cachyos-kernel-manager exa
    # start packages installation
    sudo pacman -S --noconfirm --needed $(cat /tmp/paclist)
    yay -S --noconfirm --needed $(cat /tmp/yaylist)
    # remove redundant packages installed by pacman
    sudo pacman -Rns --noconfirm xdg-desktop-portal-gnome xdg-desktop-portal-gtk
    
    # plugins for nnn file manager
    sh -c "$(curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs)"
    
    # these tools are unavailable in arch repos
    sudo curl -L https://github.com/arcolinux/arcolinux_repo/raw/main/x86_64/archlinux-logout-git-23.04-05-any.pkg.tar.zst -O /tmp/archlinux-logout-git-23.04-05-any.pkg.tar.zst
    sudo pacman -U --noconfirm /tmp/archlinux-logout-git-23.01-01-any.pkg.tar.zst

    sudo curl -L https://github.com/arcolinux/arcolinux_repo/raw/main/x86_64/arcolinux-hblock-git-3.4.1-1-any.pkg.tar.zst -O /tmp/arcolinux-hblock-git-3.4.1-1-any.pkg.tar.zst
    sudo pacman -U --noconfirm /tmp/arcolinux-hblock-git-3.4.1-1-any.pkg.tar.zst

    sudo curl -L https://raw.githubusercontent.com/Athena-OS/athena-repository/main/aarch64/athena-welcome-2.0.2-2-any.pkg.tar.zst -O /tmp/https://raw.githubusercontent.com/Athena-OS/athena-repository/main/aarch64/athena-welcome-2.0.2-2-any.pkg.tar.zst
    sudo pacman -U --noconfirm /tmp/https://raw.githubusercontent.com/Athena-OS/athena-repository/main/aarch64/athena-welcome-2.0.2-2-any.pkg.tar.zst
    
    sudo curl -L https://raw.githubusercontent.com/Athena-OS/athena-repository/main/aarch64/htb-tools-1.0.6-5-any.pkg.tar.zst -O /tmp/https://raw.githubusercontent.com/Athena-OS/athena-repository/main/aarch64/htb-tools-1.0.6-5-any.pkg.tar.zst
    sudo pacman -U --noconfirm /tmp/https://raw.githubusercontent.com/Athena-OS/athena-repository/main/aarch64/htb-tools-1.0.6-5-any.pkg.tar.zst
    
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
    
    # libvirt group
    sudo usermod -aG libvirt "$(whoami)"
    sudo usermod -aG libvirt-qemu "$(whoami)"
    sudo usermod -aG kvm "$(whoami)"
    sudo usermod -aG input "$(whoami)"
    sudo usermod -aG disk "$(whoami)"

    ## for Docker
    #gpasswd -a "$name" docker
    #usermod -aG docker $(whoami)
    #sudo systemctl enable docker.service
}

create-directories() {
mkdir -p /home/$(whoami)/{documents,desktop,downloads,videos,workspace,music,pictures}
}

install-dotfiles() {
    DOTFILES="/tmp/dotfiles"
    if [ ! -d "$DOTFILES" ]
        then
            git clone --recurse-submodules "https://github.com/Twilight4/dotfiles" "$DOTFILES" >/dev/null
    fi
    
    # Prevent permission denied errors
    sudo mv -u /tmp/dotfiles/.config/* "$HOME/.config"
    sudo mv /tmp/dotfiles/.librewolf "$HOME"
    sudo mv /tmp/dotfiles/.config/.local/ "$HOME/.config"
    source "/home/$(whoami)/.config/zsh/.zshenv"
    sudo rm -rf /usr/share/fonts
    sudo fc-cache -fv
    sudo rm /home/"$(whoami)"/.bash*
    sudo chmod 755 /opt/logseq-desktop
    # Change the ownership of mpd directory
    sudo chown -R twilight:twilight ~/.config/.local
    # Cleanup home dir bloat
    mkdir -p ~/.config/.local/share/gnupg
    mkdir -p ~/.config/.local/share/cargo
    mkdir -p ~/.config/.local/share/go
    mkdir -p ~/.config/.local/share/mpd/playlists
    mkdir -p ~/.config/.local/state/mpd
    mkdir -p ~/.config/.local/state/less/history
    mkdir -p ~/.config/.local/share/nimble
    mkdir -p ~/.config/.local/share/pki
    mkdir -p ~/.config/.local/share/cache
    mkdir -p ~/cachyos-repo
    mv ~/.gnupg ~/.config/.local/share/gnupg
    mv ~/.cargo ~/.config/.local/share/cargo
    mv ~/go ~/.config/.local/share/go
    mv ~/.lesshst ~/.config/.local/state/less/history
    mv ~/.nimble ~/.config/.local/share/nimble
    mv ~/.pki ~/.config/.local/share/pki
    mv ~/.cache ~/.config/.local/share/cache
    mv ~/node_modules ~/.config
    mv ~/package.json ~/package-lock.json ~/.config/node_modules
    mv ~/.local/share* ~/.config/.local/share
    mv ~/.local/state* ~/.config/.local/state
    rm -r ~/.local
    rm ~/.viminfo
    sudo rm ~/cachyos-repo*
    rm ~/.zsh*
    rm ~/.zcompdummp*
    
    # Enable system services
    hblock                                                                            # block ads and malware domains
    playerctld daemon                                                                 # if it doesn't work try installing volumectl
    systemctl --user enable mpd.service                                               # mpd daemon
    systemctl --user enable psd.service                                               # profile sync daemon
    sudo systemctl enable vnstat.service                                              # network traffic monitor
    sudo systemctl enable bluetooth                                                   # enable bluetooth daemon
    #sudo systemctl enable ananicy.service                                             # enable ananicy daemon (cachy-os has it built in)
    sudo systemctl enable nohang-desktop.service                                      # enable nohang daemon
    sudo systemctl enable paccache.timer                                              # enable weekly pkg cache cleaning
    sudo systemctl enable libvirtd.service                                            # enable qemu/virt manager daemon
    #sudo systemctl enable --now auto-cpufreq.service                                  # install cpu performance tweaks (error)
    sudo systemctl mask power-profiles-daemon.service                                 # install cpu performance tweaks
    # Enable performance and security tweaks
    sudo systemctl enable sddm
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
Exec="$HOME/.config/hypr/scripts/starth"  # IF CRASHES TRY: bash -c "$HOME/.config/hypr/scripts/starth"
Type=Application
EOF

# SDDM rice
sudo bash -c 'cat > /etc/sddm.conf' <<-'EOF'
# Use autologin if have problems with sddm
#[Autologin]
#Session=hyprland
#User=twilight

[Theme]
#Current=archlinux-soft-grey
Current=aerial
CursorSize=24
CursorTheme=Numix-Cursor-Light
Font=JetBrains Mono
ThemeDir=/usr/share/sddm/themes
EOF

# Grub rice - using systemd-boot
#git clone https://github.com/HenriqueLopes42/themeGrub.CyberEXS
#mv themeGrub.CyberEXS CyberEXS
#sudo mv CyberEXS /boot/grub/themes/
# to finish GRUB rice issue commands:
## sudo grub-mkconfig -o /boot/grub/grub.cfg
## echo 'GRUB_THEME=/boot/grub/themes/CyberEXS/theme.txt' >> /etc/default/grub  # works only as root
    
# tmux plugin manager
[ ! -d "$XDG_CONFIG_HOME/tmux/plugins/tpm" ] \
&& git clone --depth 1 https://github.com/tmux-plugins/tpm \
"$XDG_CONFIG_HOME/tmux/plugins/tpm"

echo 'Post-Installation:
- NOW ISSUE THESE COMMANDS (must be as root)
    su
    echo 'export ZDOTDIR="$HOME"/.config/zsh' > /etc/zsh/zshenv
    exit
- check status of auto-cpufreq with this command
    sudo systemctl status auto-cpufreq
    auto-cpufreq --stats
- if you used yaylist-striped packages then change sddm.conf to archlinux theme
------- AFTER REBOOT -------
- start Default Network for Networking
    sudo virsh net-start default
    sudo virsh net-autostart default     # Check status with: sudo virsh net-list --all
- add pub key to github: Settings > SSH > New
    ssh-keygen -t ed25519 -C "your_email@example.com"
- clone logseq and dotfiles repos via SSH
    git clone git@github.com:Twilight4/dotfiles.git ~/workspace/dotfiles
    git clone git@github.com:Twilight4/logseq-notes.git ~/documents/logseq-notes
- install more packages
    sudo npm install git-file-downloader cli-fireplace git-stats
- check if profile sync daemon is running
    psd p
- uncomment last 2 lines in kitty.conf
- reload tmux plugin manager: C-a + S-i + q'
}

run "$@"
