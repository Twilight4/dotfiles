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
    sudo pacman -Syu --noconfirm
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
    yay -S --noconfirm $(cat /tmp/yaylist)
        
    # Needed if system installed in VBox
    sudo systemctl enable vboxservice.service
    
    # zsh as default terminal for user
    sudo chsh -s "$(which zsh)" "$(whoami)"
            
    ## For Docker
    #groupadd docker
    #gpasswd -a "$name" docker
    #sudo systemctl enable docker.service
}

create-directories() {
#sudo mkdir -p "/home/$(whoami)/{Document,Download,Video,workspace,Music}"
sudo mkdir -p "/opt/github/essentials"
sudo mkdir -p "/opt/powerlevel10k"
sudo mkdir -p "/usr/share/wallpapers"
}

install-dotfiles() {
    DOTFILES="/tmp/dotfiles"
    if [ ! -d "$DOTFILES" ];
        then
            git clone --recurse-submodules "https://github.com/Twilight4/dotfiles" "$DOTFILES" >/dev/null
    fi
    
    sudo mv -u /tmp/dotfiles/.config/* "$HOME/.config"
    source "/home/$(whoami)/.config/zsh/.zshenv"
    sudo rm -rf /usr/share/fonts/[71acegT]*
    sudo mv /tmp/dotfiles/fonts/MesloLGM-NF/ /usr/share/fonts/
    sudo mv /tmp/dotfiles/fonts/rofi-fonts/ /usr/share/fonts/
    sudo mv /tmp/dotfiles/wallpapers/ /usr/share/
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

echo 'Reboot now and then do a post-Installation process:
1. use command AS ROOT: echo 'export ZDOTDIR="$HOME"/.config/zsh' > /etc/zsh/.zshenv
2. to make sure source your .zshenv in home dir once again: source ~/.config/zsh/.zshenv
3. rm conflicted files in qtile dir
4. launch the x-server: startx ~/.config/x11/xinitrc
5. once plugins gets installed for zsh type a command: mv $HOME/.config/zsh/plugins/zsh-completions/zsh-completions.plugin.zsh $HOME/.config/zsh/plugins/zsh-completions/_zsh-completions.plugin.zsh
6. add ssh pub key to github
'
}

/bin/echo -e "\e[1:32mREBOOTING IN 5..4..3..2..1..\e[0n"
sleep 5
sudo reboot

run "$@"
