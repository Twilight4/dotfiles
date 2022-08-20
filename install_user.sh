#!/bin/bash
sudo pacman -S --noconfirm tar
aur_install() {
curl -O "https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz" \
&& tar -xvf "yay.tar.gz" \
&& cd "yay" \
&& makepkg --noconfirm -si \
&& cd - \
&& rm -rf "yay" "yay.tar.gz" ;
}

aur_check() {
qm=$(pacman -Qm | awk '{print $1}')
for arg in "$@"
do
if [[ "$qm" != *"$arg"* ]]; then
yay --noconfirm -S "$arg" &>> /tmp/aur_install \
|| aur_install "$arg" &>> /tmp/aur_install
fi
done
}

cd /tmp
dialog --infobox "Installing \"Yay\", an AUR helper..." 10 60
aur_check yay
count=$(wc -l < /tmp/aur_queue)
c=0
cat /tmp/aur_queue | while read -r line
do
c=$(( "$c" + 1 ))
dialog --infobox \
"AUR install - Downloading and installing program $c out of $count:
$line..." \
10 60
aur_check "$line"
done

DOTFILES="/home/$(whoami)/.config"
if [ ! -d "$DOTFILES" ]; then
git clone https://github.com/Twilight4/dotfiles/.config.git \
"$DOTFILES" >/dev/null
fi
source "$DOTFILES/zsh/.zshenv"

# tmux plugin manager
[ ! -d "$XDG_CONFIG_HOME/tmux/plugins/tpm" ] \
&& git clone https://github.com/tmux-plugins/tpm \
"$XDG_CONFIG_HOME/tmux/plugins/tpm"
