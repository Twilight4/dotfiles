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
source ./library.sh
source ./confirm-start.sh
source ./install-hypr-packages.sh
source ./system-tweaks.sh
source ./cleanup-homedir.sh
source ./wallpaper.sh
source ./install-fonts.sh
source ./install-dotfiles.sh
source ./remove-buttons.sh
source ./zsh.sh
source ./nvchad.sh
source ./fzf.sh
source ./auto-cpufreq.sh
source ./enable-services.sh
source ./locales.sh
source ./prompt-reboot.sh
# Don't use anymore
#source ./display-manager.sh
#source ./tty-login.sh
#source ./nnn.sh
#source ./emacs.sh
#source ./install-grub-theme.sh
#source ./systemd-boot.sh
