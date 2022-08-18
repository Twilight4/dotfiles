#!/bin/bash

name=$(cat /tmp/user_name)

apps_path="/tmp/apps.csv"
curl https://raw.githubusercontent.com/Twiligh4\
/arch_installer/master/apps.csv > $apps_path

dialog --title "Welcome!" \
--msgbox "Welcome to the installation script for your apps and dotfiles
!" \
10 60
apps=("essential" "Essentials" on
"tools" "Nice tools to have (highly recommended)" on
"tmux" "Tmux" on
"notifier" "Notification tools" on
"git" "Git & git tools" on
"zsh" "The Z-Shell (zsh)" on
"neovim" "Neovim" off
"firefox" "Firefox (browser)" off
"lynx" "Lynx (browser)" off
"file manager" "lf" off
"min" "Min (browser)" off
"alacritty" "Alacritty" off
"vbox" "vbox-utils") off

dialog --checklist \
"You can now choose what group of application you want to install. \n\n\
You can select an option with SPACE and valid your choices with ENTER." \
0 0 0 \
"${apps[@]}" 2> app_choices
choices=$(cat app_choices) && rm app_choices

selection="^$(echo $choices | sed -e 's/ /,|^/g'),"
lines=$(grep -E "$selection" "$apps_path")
count=$(echo "$lines" | wc -l)
packages=$(echo "$lines" | awk -F, {'print $2'})

echo "$selection" "$lines" "$count" >> "/tmp/packages"

pacman -Syu --noconfirm

rm -f /tmp/aur_queue

dialog --title "Let's go!" --msgbox \
"The system will now install everything you need.\n\n\
It will take some time.\n\n " \
13 60

c=0
echo "$packages" | while read -r line; do
c=$(( "$c" + 1 ))
dialog --title "Arch Linux Installation" --infobox \
"Downloading and installing program $c out of $count: $line..." \
8 70
((pacman --noconfirm --needed -S "$line" > /tmp/arch_install 2>&1) \
|| echo "$line" >> /tmp/aur_queue) \
|| echo "$line" >> /tmp/arch_install_failed
if [ "$line" = "zsh" ]; then
# Set Zsh as default terminal for our user
chsh -s "$(which zsh)" "$name"
fi
if [ "$line" = "networkmanager" ]; then
systemctl enable NetworkManager.service
fi
done
