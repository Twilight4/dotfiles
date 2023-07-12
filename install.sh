#!/usr/bin/env bash

# Warning:
# I recommend utilizing the CachyOS installation of Arch Linux for optimal performance and streamlined setup experience.
# Prior to executing this script, it is imperative that users have previously run the "install-tweaks.sh" script available in the "alis-iso" repository.
# This preliminary step ensures the successful application of necessary system tweaks and optimizations, adding additional pacman repositories and 
# enhancing system security and the overall performance and stability.
#
# Title: Package Installer and User System Configuration Bootstrap script.
# Description: The script automates the installation of user packages and configures system settings and services. 
# It streamlines the setup process, saving time and effort for system administrators and power users and ensuring
# a consistent and efficient setup experience across multiple systems.

main() {
    update-system
    install-yay
    remove-distro-bloat
    install-packages
    set-user-groups
    install-dotfiles
    enable-services
    set-leftovers
    post-install-message
}

update-system() {
    sudo pacman --noconfirm -Syu
}

install-yay() {
    # Install required dependencies
    sudo pacman -S --noconfirm git ccache
    # Install yay package manager from AUR
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin
    makepkg --noconfirm -si
    cd ..
    rm -rf yay-bin
    # Clean up unused dependencies
    sudo pacman -Rns --noconfirm $(pacman -Qdtq)
}

remove-distro-bloat() {
    # Remove redundant packages installed by alis script
    #sudo pacman -Rns --noconfirm sddm linux linux-headers
    # Remove redundant packages installed by cachyos
    #sudo pacman -Rns cachyos-fish-config fish-autopair fisher fish-pure-prompt fish cachyos-zsh-config oh-my-zsh-git cachyos-hello cachyos-kernel-manager exa alacritty micro cachyos-micro-settings btop cachyos-packageinstaller vim
    # Remove redundant packages installed by pacman (on Hyprland)
    #sudo pacman -Rns --noconfirm xdg-desktop-portal-gnome xdg-desktop-portal-gtk xdg-desktop-portal-wlr

    # First remove bloat that came with distro installation
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
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    )

    for package in "${cachyos_bloat[@]}"; do
      if pacman -Qs "$package" > /dev/null 2>&1; then
        echo "Removing $package..."
        sudo pacman -Rsn --noconfirm "$package"
      else
        echo "$package is not installed."
      fi
    done
}

install-packages() {
    # Download paclist
    paclist_path="/tmp/paclist-stripped"
    curl "https://raw.githubusercontent.com/Twilight4/arch-install/master/paclist-stripped" > "$paclist_path"
    echo $paclist_path

    # Download yaylist
    yaylist_path="/tmp/yaylist-stripped"
    curl "https://raw.githubusercontent.com/Twilight4/arch-install/master/yaylist-stripped" > "$yaylist_path"
    echo $yaylist_path

    # Start packages installation
    sudo pacman -S --needed $(cat /tmp/paclist-stripped)
    yay -S --needed $(cat /tmp/yaylist-stripped)
    
    # Installing nnn file manager plugins if not installled
    plugins_dir="$HOME/.config/nnn/plugins"

    if [ -z "$(ls -A "$plugins_dir")" ]; then
        echo "Fetching nnn plugins..."

        sh -c "$(curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs)"

        echo "nnn plugins fetched."
    else
        echo "nnn plugins directory is not empty."
    fi
    
    # These tools are unavailable in arch repos
    sudo curl -L https://raw.githubusercontent.com/Athena-OS/athena-repository/main/aarch64/athena-welcome-2.0.2-2-any.pkg.tar.zst -O /tmp/https://raw.githubusercontent.com/Athena-OS/athena-repository/main/aarch64/athena-welcome-2.0.2-2-any.pkg.tar.zst
    sudo pacman -U --noconfirm /tmp/https://raw.githubusercontent.com/Athena-OS/athena-repository/main/aarch64/athena-welcome-2.0.2-2-any.pkg.tar.zst
    
    sudo curl -L https://raw.githubusercontent.com/Athena-OS/athena-repository/main/aarch64/htb-tools-1.0.6-5-any.pkg.tar.zst -O /tmp/https://raw.githubusercontent.com/Athena-OS/athena-repository/main/aarch64/htb-tools-1.0.6-5-any.pkg.tar.zst
    sudo pacman -U --noconfirm /tmp/https://raw.githubusercontent.com/Athena-OS/athena-repository/main/aarch64/htb-tools-1.0.6-5-any.pkg.tar.zst

    # Install auto-cpufreq if not installed
    if ! command -v auto-cpufreq >/dev/null; then
        echo "Installing auto-cpufreq..."

        git clone https://github.com/AdnanHodzic/auto-cpufreq.git
        cd auto-cpufreq && sudo ./auto-cpufreq-installer
        sudo auto-cpufreq --install

        echo "auto-cpufreq installed."
    else
        echo "auto-cpufreq is already installed."
    fi

    # Clone SecLists repo if does not exist
    payloads_dir="/usr/share/payloads"
    seclists_dir="$payloads_dir/SecLists"

    if [ ! -d "$payloads_dir" ] || [ ! -d "$seclists_dir" ]; then
        echo "Creating directories and cloning SecLists repository..."

        sudo mkdir -p "$payloads_dir"
        sudo git clone https://github.com/danielmiessler/SecLists.git "$seclists_dir"

        echo "SecLists repository cloned to $seclists_dir."
    else
        echo "SecLists repository already exists in $seclists_dir."
    fi

    # Zsh as default shell
    default_shell=$(getent passwd "$(whoami)" | cut -d: -f7)
    if [ "$default_shell" != "$(which zsh)" ]; then
        echo "Zsh is not the default shell. Changing shell..."
        sudo chsh -s "$(which zsh)" "$(whoami)"
        echo "Shell changed to Zsh."
    else
        echo "Zsh is already the default shell."
    fi

    # Export default PATH to zsh config
    zshenv_file="/etc/zsh/zshenv"
    line_to_append='export ZDOTDIR="$HOME"/.config/zsh'

    if [ ! -f "$zshenv_file" ]; then
        echo "Creating $zshenv_file..."
        echo "$line_to_append" | sudo tee "$zshenv_file" >/dev/null
        echo "$zshenv_file created."
    else
        echo "$zshenv_file already exists."
    fi
}
    
set-user-groups() {
    # Razer, audit and sddm autologin group
    add_groups=(
     plugdev
     audit
     autologin
    )

    for group in "${add_groups[@]}"; do
      if ! getent group "$group" >/dev/null; then
        echo "Creating group '$group'..."
        sudo groupadd "$group"
      else
        echo "Group '$group' already exists."
      fi
    done

    # Libvirtd groups (for virt-manager)
    usermod_groups=(
      libvirt
      libvirt-qemu
      kvm
      input
      disk
      #docker
    )

    gpasswd_groups=(
      audit
      autologin
      plugdev
      mpd
      #docker
    )

    username="$(whoami)"

    # Adding user to groups using usermod
    for group in "${usermod_groups[@]}"; do
      if ! groups "$username" | grep -q "\<$group\>"; then
        echo "Adding user '$username' to group '$group'..."
        sudo usermod -aG "$group" "$username"
      else
        echo "User '$username' is already a member of group '$group'."
      fi
    done

    # Adding user to groups using gpasswd
    for group in "${gpasswd_groups[@]}"; do
      if ! groups "$username" | grep -q "\<$group\>"; then
        echo "Adding user '$username' to group '$group'..."
        sudo gpasswd -a "$username" "$group"
        sudo chmod 710 "/home/$(whoami)"      # needed for mpd group
      else
        echo "User '$username' is already a member of group '$group'."
      fi
    done
}

install-dotfiles() {
    DOTFILES="/tmp/dotfiles"
    if [ ! -d "$DOTFILES" ]
        then
            git clone --recurse-submodules "https://github.com/Twilight4/dotfiles" "$DOTFILES" >/dev/null
    fi
    
    # Remove auto-generated bloat
    sudo rm -rf /usr/share/fonts/encodings
    sudo fc-cache -fv
    rm -rf .config/{fish,gtk-3.0,ibus,kitty,micro,nautilus,pulse,yay,user-dirs.dirs,user-dirs,locate,dconf}
    rm -rf .config/.gsd-keyboard.settings-ported
    # Copy dotfiles
    rsync -av  /tmp/dotfiles/ ~
    rm ~/README.md
    # Use the same nvim config for sudo nvim
    sudo cp -r ~/.config/nvim /root/.config/
    # Change ownerships of logseq and mpd directory
    sudo chown -R twilight:twilight ~/.config/.local
    sudo chmod 755 /opt/logseq-desktop

    # Create needed directories
    directories=(
        ~/{documents,desktop,downloads,videos,workspace,music,pictures}
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

    # Setting mime type for org mode (org mode is not recognised as it's own mime type by default)
    update-mime-database ~/.config/.local/share/mime
    xdg-mime default emacs.desktop text/org


enable-services() {
    services=(
        sddm
        apparmor
        firewalld
        irqbalance
        chronyd
        systemd-oomd
        systemd-resolve
        paccache.timer      # enable weekly pkg cache cleaning
        ananicy             # enable ananicy daemon (CachyOS has it built in)
        nohang-desktop
        sshd.service
        bluetooth
        vnstat              # network traffic monitor
        libvirtd            # enable qemu/virt manager daemon
        #auditd             # it is broken
        #docker
    )

    # Enable services if they exist and are not enabled
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

    # Enable psd service as user if service exists and isn not enabled
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
    # Disable the systemd-boot startup entry if systemd-boot is installed
    if [ -d "/sys/firmware/efi/efivars" ] && [ -d "/boot/loader" ]; then
        echo "Disabling systemd-boot startup entry"
        sudo sed -i 's/^timeout/# timeout/' /boot/loader/loader.conf
        echo "Disabled systemd-boot startup entry"
    else
        echo "systemd-boot is not being used."
    fi

    # Set data locale english if it is not set
    if [[ "$(localectl status)" != *"LC_TIME=en_US.UTF8"* ]]; then
        echo "Setting LC_TIME to English..."
        sudo localectl set-locale LC_TIME=en_US.UTF8
        echo "LC_TIME set to English."
    else
        echo "LC_TIME is already set to English."
    fi

    # Install GRUB theme if GRUB is installed
    if command -v grub-install >/dev/null && ! command -v bootctl >/dev/null; then
        echo "Installing GRUB theme..."

        # Clone theme repository
        git clone https://github.com/HenriqueLopes42/themeGrub.CyberEXS
        mv themeGrub.CyberEXS CyberEXS

        # Move theme directory to GRUB themes directory
        sudo mv CyberEXS /boot/grub/themes/

        # Update GRUB configuration
        sudo grub-mkconfig -o /boot/grub/grub.cfg

        # Set GRUB theme in GRUB configuration
        echo 'GRUB_THEME=/boot/grub/themes/CyberEXS/theme.txt' | sudo tee -a /etc/default/grub

        echo "GRUB theme installed."
    else
        echo "GRUB bootloader is not installed, using systemd-boot"
    fi

    # Create Hyprland desktop entry if Hyprland is installed
    if command -v hyprland >/dev/null; then
        echo "Creating hyprland desktop entry..."

        sudo bash -c 'cat > /usr/share/wayland-sessions/hyprland.desktop' <<-'EOF'
        [Desktop Entry]
        Name=Hyprland
        Comment=hyprland
        Exec="$HOME/.config/hypr/scripts/starth"   # IF CRASHES TRY: bash -c "$HOME/.config/hypr/scripts/starth"
        Type=Application
        EOF

        echo "hyprland desktop entry created."
    else
        echo "hyprland is not installed."
    fi

    # SDDM rice (don't install GDM cuz it installs GNOME DE as dependency)
    if command -v sddm >/dev/null; then
        echo "Creating /etc/sddm.conf file..."

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

        echo "/etc/sddm.conf file created."
    else
        echo "sddm is not installed."
    fi
}

post-install-message () {}
    echo 'Post-Installation:
    - check auto-cpufreq stats
        auto-cpufreq --stats
    - to force and override auto-cpufreq governor use of either "powersave" or "performance" governor
        sudo auto-cpufreq --force=performance
        sudo auto-cpufreq --force=powersave
        sudo auto-cpufreq --force=reset         # Setting to "reset" will go back to normal mode
    ------- AFTER REBOOT -------
    - start Default Network for virt-manager
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

main "$@"
