# THIS IS INSTALLATION FOR ONLY MY PERSONAL DOTFILES AND PACKAGES AFTER MINIMAL BASE-INSTALL OF ARCHINSTALL SCRIPT, ITS NOT THE SAME AS IN THE ARCH-INSTALL REPO

#!/bin/bash

run() {
    disable-horrible-beep
    update-system
    set-user-permissions
    set-pacman-config
    download-paclist
    download-yaylist
    install-yay
    install-apps
    create-directories
    install-dotfiles
    install-ghapps
}

disable-horrible-beep() {
    rmmod pcspkr
    echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf
}

update-system() {
    pacman -Syu --noconfirm
}

set-user-permissions() {
    curl "$https://raw.githubusercontent.com/Twilight4/arch-install/master/sudoers" > /etc/sudoers
}

set-pacman-config() {
    curl "$https://raw.githubusercontent.com/Twilight4/arch-install/master/pacman.conf" > /etc/pacman.conf
}

download-paclist() {
    paclist_path="/tmp/paclist" 
    curl "https://raw.githubusercontent.com/Twilight4/arch-install/master/paclist" > "$paclist_path"

    echo $paclist_path
}

download-yaylist() {
    yaylist_path="/tmp/yaylist"
    curl "https://raw.githubusercontent.com/Twilight4/arch-install/master/yaylist" > "$yaylist_path"
    echo 'export ZDOTDIR="$HOME"/.config/zsh' >> /etc/zsh/zshenv

    echo $yaylist_path
}

install-yay() {
    sudo pacman -S --noconfirm tar
    curl -O "https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz" \
    && tar -xvf "yay.tar.gz" \
    && cd "yay" \
    && makepkg --noconfirm -si \
    && cd - \
    && rm -rf "yay" "yay.tar.gz" ;
}

install-apps() {
    sudo pacman -S --noconfirm $(cat /tmp/paclist)
    pip install --no-cache-dir cairocffi
    pip install qtile
    yay -S --noconfirm $(cat /tmp/yaylist)
        
    # Needed if system installed in VBox
    sudo systemctl enable vboxservice.service
    
    # zsh as default terminal for user
    sudo chsh -s "$(which zsh)" "$(whoami)"
    
    # Needed if system installed in VMWare
    if [ "$(cat /tmp/paclist)" = "xf86-video-vmware" ]; then
        sudo systemctl enable vmtoolsd.service
        sudo systemctl enable vmware-vmblock-fuse.service
    fi
            
    ## For Docker
    #groupadd docker
    #gpasswd -a "$name" docker
    #sudo systemctl enable docker.service
}

create-directories() {
#sudo mkdir -p "/home/$(whoami)/{Document,Download,Video,workspace,Music}"
sudo mkdir -p "/opt/github/essentials"
sudo mkdir -p "/opt/powerlevel10k"
}

install-dotfiles() {
    DOTFILES="/tmp/dotfiles"
    if [ ! -d "$DOTFILES" ];
        then
            git clone --recurse-submodules "https://github.com/Twilight4/dotfiles" "$DOTFILES" >/dev/null
    fi
    
    sudo mv -u /tmp/dotfiles/.config/* "$HOME/.config"
    source "/home/$(whoami)/.config/zsh/.zshenv"
    sudo rm -rf /usr/share/fonts/[71aceT]*
    sudo mv /tmp/dotfiles/fonts/MesloLGM-NF/ /usr/share/fonts/
    sudo mv /tmp/dotfiles/fonts/rofi-fonts/ /usr/share/fonts/
    sudo mv /tmp/dotfiles/wallpapers/ /opt/
    sudo rm /home/$(whoami)/.bash*
    sudo chmod 755 $XDG_CONFIG_HOME/qtile/autostart.sh
    sudo chmod 755 $XDG_CONFIG_HOME/polybar/launch.sh
    sudo chmod 755 $HOME/.config/polybar/polybar-scripts/*
    sudo chmod 755 $HOME/.config/rofi/applets/bin/*
    sudo chmod 755 $XDG_CONFIG_HOME/rofi/applets/shared/theme.bash
    sudo chmod 755 $XDG_CONFIG_HOME/rofi/launcher/launcher.sh
    sudo mv $HOME/.config/rofi/applets/bin/* /usr/bin/
    git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
    git config --global user.email "electrolight071@gmail.com"
    git config --global user.name "Twilight4"
}

install-ghapps() {
    GHAPPS="/opt/github/essentials"
    if [ ! -d "$GHAPPS" ];
        then
            sudo git clone "https://github.com/shlomif/lynx-browser"
            sudo git clone "https://github.com/chubin/cheat.sh"
            sudo git clone "https://github.com/smallhadroncollider/taskell"
            sudo git clone "https://github.com/christoomey/vim-tmux-navigator"
            sudo git clone "https://github.com/Swordfish90/cool-retro-term"
    fi
    
# powerlevel10k
[ ! -d "/opt/powerlevel10k" ] \
&& sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
"/opt/powerlevel10k"

# XDG ninja
[ ! -d "$HOME/xdg-ninja" ] \
&& git clone https://github.com/b3nj5m1n/xdg-ninja \
"$HOME/xdg-ninja"

# tmux plugin manager
[ ! -d "$XDG_CONFIG_HOME/tmux/plugins/tpm" ] \
&& git clone --depth 1 https://github.com/tmux-plugins/tpm \
"$XDG_CONFIG_HOME/tmux/plugins/tpm"

# neovim plugin manager
[ ! -d "$XDG_CONFIG_HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" ] \
&& git clone https://github.com/wbthomason/packer.nvim \
"$XDG_CONFIG_HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"

echo 'Post-Installation:
- after reboot use startx ~/.config/x11/xinitrc
- use command AS ROOT: echo 'export ZDOTDIR="$HOME"/.config/zsh' > /etc/zsh/.zshenv
- rm conflicted files in qtile dir
- once plugins gets installed for zsh type a command: mv $HOME/.config/zsh/plugins/zsh-completions/zsh-completions.plugin.zsh $HOME/.config/zsh/plugins/zsh-completions/_zsh-completions.plugin.zsh
- add ssh pub key to github
'

sudo reboot
}

run "$@"
