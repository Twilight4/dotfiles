#!/bin/bash

################
# Presentation #
################
clear
echo "
          _ ._  _ , _ ._
        (_ ' ( \`  )_  .__)
      ( (  (    )   \`)  ) _)
     (__ (_   (_ . _) _) ,__)
           ~~\ ' . /~~
         ,::: ;   ; :::,
        ':::::::::::::::'
 ____________/_ __ \______________
|                                 |
| Welcome to Twilight4's dotfiles |
|_________________________________|
"
echo "This script will delete all your configuration files."
echo "Use at your own risk."
echo ""

################
# Installation #
################
source ~/dotfiles/.config/.install/library.sh
source ~/dotfiles/.config/.install/confirm-start.sh
source ~/dotfiles/.config/.install/install-hypr-packages.sh
source ~/dotfiles/.config/.install/system-tweaks.sh
source ~/dotfiles/.config/.install/cleanup-homedir.sh
source ~/dotfiles/.config/.install/wallpaper.sh
source ~/dotfiles/.config/.install/install-fonts.sh
source ~/dotfiles/.config/.install/install-dotfiles.sh
source ~/dotfiles/.config/.install/remove-buttons.sh
source ~/dotfiles/.config/.install/zsh.sh
source ~/dotfiles/.config/.install/nvchad.sh
source ~/dotfiles/.config/.install/fzf.sh
source ~/dotfiles/.config/.install/auto-cpufreq.sh
source ~/dotfiles/.config/.install/enable-services.sh
source ~/dotfiles/.config/.install/locales.sh
source ~/dotfiles/.config/.install/prompt-reboot.sh
# Don't use anymore
#source ~/dotfiles/.config/.install/display-manager.sh
#source ~/dotfiles/.config/.install/tty-login.sh
#source ~/dotfiles/.config/.install/nnn.sh
#source ~/dotfiles/.config/.install/emacs.sh
#source ~/dotfiles/.config/.install/install-grub-theme.sh
#source ~/dotfiles/.config/.install/systemd-boot.sh
