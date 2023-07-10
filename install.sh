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
    enable-services
    set-leftovers
}

update-system() {
    sudo pacman --noconfirm -Syu
}

download-paclist() {
    paclist_path="/tmp/paclist-stripped"
    curl "https://raw.githubusercontent.com/Twilight4/arch-install/master/paclist-stripped" > "$paclist_path"

    echo $paclist_path
}

download-yaylist() {
    yaylist_path="/tmp/yaylist-stripped"
    curl "https://raw.githubusercontent.com/Twilight4/arch-install/master/yaylist-stripped" > "$yaylist_path"

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
    # if you used alis script then remove redundant packages installed by it
    #sudo pacman -Rns --noconfirm sddm linux linux-headers
    # remove redundant packages installed by cachyos
    #sudo pacman -Rns cachyos-fish-config fish-autopair fisher fish-pure-prompt fish cachyos-zsh-config oh-my-zsh-git cachyos-hello cachyos-kernel-manager exa alacritty micro cachyos-micro-settings btop cachyos-packageinstaller vim
    cachyos_bloat=(
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
      vim
    )

    for package in "${cachyos_bloat[@]}"; do
      if pacman -Qs "$package" > /dev/null 2>&1; then
        echo "Removing $package..."
        sudo pacman -Rsn --noconfirm "$package"
      else
        echo "$package is not installed."
      fi
    done

    # start packages installation
    sudo pacman -S --needed $(cat /tmp/paclist-stripped)
    yay -S --needed $(cat /tmp/yaylist-stripped)
    # remove redundant packages installed by pacman (on Hyprland)
    #sudo pacman -Rns --noconfirm xdg-desktop-portal-gnome xdg-desktop-portal-gtk xdg-desktop-portal-wlr
    
    # plugins for nnn file manager
    sh -c "$(curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs)"
    
    # these tools are unavailable in arch repos
    sudo curl -L https://github.com/arcolinux/arcolinux_repo/raw/main/x86_64/arcolinux-hblock-git-3.4.1-1-any.pkg.tar.zst -O /tmp/arcolinux-hblock-git-3.4.1-1-any.pkg.tar.zst
    sudo pacman -U --noconfirm /tmp/arcolinux-hblock-git-3.4.1-1-any.pkg.tar.zst

    sudo curl -L https://raw.githubusercontent.com/Athena-OS/athena-repository/main/aarch64/athena-welcome-2.0.2-2-any.pkg.tar.zst -O /tmp/https://raw.githubusercontent.com/Athena-OS/athena-repository/main/aarch64/athena-welcome-2.0.2-2-any.pkg.tar.zst
    sudo pacman -U --noconfirm /tmp/https://raw.githubusercontent.com/Athena-OS/athena-repository/main/aarch64/athena-welcome-2.0.2-2-any.pkg.tar.zst
    
    sudo curl -L https://raw.githubusercontent.com/Athena-OS/athena-repository/main/aarch64/htb-tools-1.0.6-5-any.pkg.tar.zst -O /tmp/https://raw.githubusercontent.com/Athena-OS/athena-repository/main/aarch64/htb-tools-1.0.6-5-any.pkg.tar.zst
    sudo pacman -U --noconfirm /tmp/https://raw.githubusercontent.com/Athena-OS/athena-repository/main/aarch64/htb-tools-1.0.6-5-any.pkg.tar.zst

    # clone SecLists repo
    [ ! -d "/usr/share/payloads/SecLists" ] \
    && mkdir -p /usr/share/payloads/SecLists \
    && git clone https://github.com/danielmiessler/SecLists \
    "/usr/share/payloads/SecLists"

    # zsh as default shell
    default_shell=$(getent passwd "$(whoami)" | cut -d: -f7)
    if [ "$default_shell" != "$(which zsh)" ]; then
        echo "Zsh is not the default shell. Changing shell..."
        sudo chsh -s "$(which zsh)" "$(whoami)"
        echo "Shell changed to Zsh."
    else
        echo "Zsh is already the default shell."
    fi
    
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
    
    # Rm auto-generated bloat
    sudo rm -rf /usr/share/fonts/encodings
    sudo fc-cache -fv
    rm -rf .config/{fish,gtk-3.0,ibus,kitty,micro,nautilus,pulse,yay,user-dirs.dirs,user-dirs,locate,dconf}
    rm -rf .config/.gsd-keyboard.settings-ported
    # Cp dotfiles
    rsync -av  /tmp/dotfiles/ ~
    rm ~/README.md
    # Change ownerships of logseq and mpd directory
    sudo chown -R twilight:twilight ~/.config/.local
    sudo chmod 755 /opt/logseq-desktop

    # Create needed directories
    directories=(
        ~/.config/.local/share/gnupg
        ~/.config/.local/share/cargo
        ~/.config/.local/share/go
        ~/.config/.local/share/mpd/playlists
        ~/.config/.local/state/mpd
        ~/.config/.local/state/less/history
        ~/.config/.local/share/nimble
        ~/.config/.local/share/pki
        ~/.config/.local/share/cache
        ~/cachyos-repo
        ~/documents/Org/roam
    )

    for directory in "${directories[@]}"; do
        if [ ! -d "$directory" ]; then
            echo "Creating directory: $directory..."
            mkdir -p "$directory"
        else
            echo "Directory already exists: $directory."
        fi
    done

    # Cleanup home dir bloat
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
    sudo rm /home/"$(whoami)"/.bash*
    rm -r ~/.local
    rm -rf ~/.git
    rm -r ~/{Documents,Pictures,Desktop,Downloads,Templates,Music,Videos,Public}
    rm ~/.viminfo
    sudo rm ~/cachyos-repo*
    rm -r ~/cachyos-repo
    rm ~/.zsh*
    rm ~/.zcompdummp*

    # Setting mime type for org mode (org mode isn't recognised as it's own mime type by default)
    update-mime-database ~/.config/.local/share/mime
    xdg-mime default emacs.desktop text/org

    # auto-cpufreq-installer
    git clone https://github.com/AdnanHodzic/auto-cpufreq.git
    cd auto-cpufreq && sudo ./auto-cpufreq-installer
    sudo auto-cpufreq --install

enable-services() {
    services=(
        sddm
        apparmor
        firewalld
        irqbalance
        chronyd
        systemd-oomd
        paccache.timer      # enable weekly pkg cache cleaning
        ananicy             # enable ananicy daemon (cachy-os has it built in)
        nohang-desktop
        sshd.service
        bluetooth
        vnstat              # network traffic monitor
        libvirtd            # enable qemu/virt manager daemon
        #auditd             # it's broken
    )

    for service in "${services[@]}"; do
        if systemctl list-unit-files --type=service | grep -q "^$service.service"; then
            if ! systemctl is-enabled --quiet "$service"; then
                echo "Enabling service: $service..."
                sudo systemctl enable "$service"
            else
                echo "Service already enabled: $service."
            fi
        else
            echo "Service does not exist: $service."
        fi
    done

    # Enable psd service as user if service exists
    if systemctl list-unit-files --user --type=service | grep -q "^psd.service"; then
        if ! systemctl --user is-enabled --quiet psd.service; then
            echo "Enabling service: psd.service..."
            systemctl --user enable psd.service                  # profile sync daemon
        else
            echo "Service already enabled: psd.service."
        fi
    else
        echo "Service does not exist: psd.service."
    fi

    # Enable mpd service as user if service exists
    #if ! systemctl list-unit-files --user --type=service | grep -q "^mpd.service"; then
    #    echo "Service does not exist: mpd.service. Adding and enabling..."
    #    systemctl --user enable mpd.service
    #else
    #    if ! systemctl --user is-enabled --quiet mpd.service; then
    #        echo "Enabling service: mpd.service..."
    #        systemctl --user enable mpd.service                  # mpd daemon
    #    else
    #        echo "Service already enabled: mpd.service."
    #    fi
    #fi

    # Other services
    hblock                               # block ads and malware domains
    #playerctld daemon                   # if it doesn't work try installing volumectl
}

set-leftovers() {
    # Disable the systemd-boot startup entry
    sudo sed -i 's/^timeout/# timeout/' /boot/loader/loader.conf 
    # Change data locale back to english
    sudo localectl set-locale LC_TIME=en_US.UTF8

# Hyprland desktop entry
#sudo mv /tmp/dotfiles/hyprland.desktop /usr/share/wayland-sessions/hyprland.desktop
sudo bash -c 'cat > /usr/share/wayland-sessions/hyprland.desktop' <<-'EOF'
[Desktop Entry]
Name=Hyprland
Comment=hyprland
Exec="$HOME/.config/hypr/scripts/starth"  # IF CRASHES TRY: bash -c "$HOME/.config/hypr/scripts/starth"
Type=Application
EOF

# SDDM rice (don't install GDM cuz it installs and logs into GNOME instead)
sudo bash -c 'cat > /etc/sddm.conf' <<-'EOF'
# Use autologin if have problems with sddm
#[Autologin]
#Session=hyprland
#User=twilight

[Theme]
Current=astronaut
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


echo 'Post-Installation:
- NOW ISSUE THESE COMMANDS (must be as root)
    su
    echo 'export ZDOTDIR="$HOME"/.config/zsh' > /etc/zsh/zshenv
    exit
- check status of auto-cpufreq with this command
    sudo systemctl status auto-cpufreq
    auto-cpufreq --stats
  - to force, override and persist after reboot the use of either "powersave" or "performance" governor use
      sudo auto-cpufreq --force=performance
      sudo auto-cpufreq --force=powersave
      sudo auto-cpufreq --force=reset         # Setting to "reset" will go back to normal mode
------- AFTER REBOOT -------
- start Default Network for Networking
    sudo virsh net-start default
    sudo virsh net-autostart default     # Check status with: sudo virsh net-list --all
- add pub key to github: Settings > SSH > New
    ssh-keygen -t ed25519 -C "your_email@example.com"
- clone logseq and dotfiles repos via SSH
    git clone git@github.com:Twilight4/dotfiles.git ~/workspace/dotfiles
    git clone git@github.com:Twilight4/cheats.git ~/workspace/cheats
    git clone git@github.com:Twilight4/logseq-notes.git ~/documents/logseq-notes
- install more packages
    sudo npm install git-file-downloader cli-fireplace git-stats
- check if profile sync daemon is running
    psd p
- uncomment last 2 lines in kitty.conf'
}

run "$@"
