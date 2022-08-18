#!/bin/bash

apps_path="/tmp/apps.csv"
curl https://raw.githubusercontent.com/<Twiligh4>\
/arch_installer/master/apps.csv > $apps_path                  #apps .csv contains all the applications we want to install on our new system

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
"neovim" "Neovim" on
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
