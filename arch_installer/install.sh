#!/bin/bashsudo pacman -S --noconfirm tar curl
aur_install() {
curl -O "https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz" \
&& tar -xvf "yay.tar.gz" \
&& cd "yay" \
&& makepkg --noconfirm -si \
&& cd - \
&& rm -rf "yay" "yay.tar.gz" ;
}

DOTFILES="/home/$(whoami)/.config"
if [ ! -d "$DOTFILES" ]; then
git clone https://github.com/Twilight4/dotfiles.git \
"$DOTFILES" >/dev/null
fi

rm ~/dotfiles/fonts/MesloLGS-NF/README.md
rm ~/dotfiles/README.md
pip install --no-cache-dir cairocffi
sudo systemctl enable vboxservice.service
chsh -s /bin/zsh
yay -Syu
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /opt/powerlevel10k
echo 'export ZDOTDIR="$HOME"/.config/zsh' >> /etc/zsh/zshenv
mv /home/twilight/.config/zsh/plugins/zsh-completions/zsh-completions.plugin.zsh /home/twilight/.config/zsh/plugins/zsh-completions/_zsh-completions.plugin.zsh
mv ~/dotfiles/fonts/* /usr/share/fonts
yay -Sc
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
git config --global user.email "electrolight071@gmail.com"
git config --global user.name "<Twilight4>"

sudo pacman -S $(cat paclist)
yay -S $(cat yaylist)
