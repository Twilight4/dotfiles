#!/bin/bashsudo pacman -S --noconfirm tar curl git
aur_install() {
curl -O "https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz" \
&& tar -xvf "yay.tar.gz" \
&& cd "yay" \
&& makepkg --noconfirm -si \
&& cd - \
&& rm -rf "yay" "yay.tar.gz" ;
}

DOTFILES="/home/twilight/"
if [ ! -d "$DOTFILES" ]; then
git clone https://github.com/Twilight4/dotfiles.git \
"$DOTFILES" >/dev/null
fi

cd ~/dotfiles.git
mv /home/twilight/dotfiles.git/.config /home/twilight/
mv /home/twilight/dotfiles.git/fonts/MesloLGS-NF/* /usr/share/fonts
mv /home/twilight/dotfiles.git/wallpapers /opt
mv /home/twilight/dotfiles.git/wallpapers/arch_installer/paclist ~
mv /home/twilight/dotfiles.git/wallpapers/arch_installer/paclist ~
cd ~twilight/
rm -rf dotfiles.git

pip install --no-cache-dir cairocffi
echo 'export ZDOTDIR="$HOME"/.config/zsh' >> /etc/zsh/zshenv
sudo systemctl enable vboxservice.service
chsh -s /bin/zsh
rm .bash*
mkdir -p /opt/github /opt/github/essentials
yay -Syu --noconfirm
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /opt/powerlevel10k
mv /home/twilight/.config/dotfiles.git/zsh/plugins/zsh-completions/zsh-completions.plugin.zsh /home/twilight/.config/zsh/plugins/zsh-completions/_zsh-completions.plugin.zsh

yay -Yc --noconfirm
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
git config --global user.email "electrolight071@gmail.com"
git config --global user.name "<Twilight4>"

sudo pacman -S $(cat paclist)
yay -S $(cat yaylist)
rm ~/paclist
rm ~/yaylist

git clone https://github.com/shlomif/lynx-browser /opt/github/essentials
git clone https://github.com/chubin/cheat.sh /opt/github/essentials
git clone https://github.com/smallhadroncollider/taskell /opt/github/essentials
git clone https://github.com/christoomey/vim-tmux-navigator /opt/github/essentials
git clone https://github.com/tmux-plugins/tpm /opt/github/essentials
git clone https://github.com/wbthomason/packer.nvim /opt/github/essentials
git clone https://github.com/b3nj5m1n/xdg-ninja ~twilight/
git clone https://github.com/shlomif/lynx-browser /opt/github/essentials

echo 'reminders for myself:
- add pub ssh key to github
- choose GTK Theme in lxappearance
'
