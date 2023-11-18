#!bin/bash

#####################
# Installation mode #
#####################

source .config/.install/colors.sh
source .config/.install/library.sh
clear

mode="live"
if [ ! -z $1 ]; then
    mode="dev"
    echo "IMPORTANT: DEV MODE ACTIVATED. "
    echo "Existing dotfiles folder will not be modified."
    echo "Symbolic links will not be created."
fi


################
# Presentation #
################

echo -e "
${GREEN}
          _ ._  _ , _ ._
        (_ ' ( \`  )_  .__)
      ( (  (    )   \`)  ) _)
     (__ (_   (_ . _) _) ,__)
           ~~\ ' . /~~
         ,::: ;   ; :::,
        ':::::::::::::::'
 ____________/_ __ \_____________
|                                |
| Welcome to Twilight4s dotfiles |
|________________________________|
"
echo ""
echo "${YELLOW} Please make sure that your system and your packages are up to date."
echo "${YELLOW} This script will delete all your configuration files."
echo "${YELLOW} Use at your own risk."
echo ""


################
# Installation #
################

source .config/.install/confirm-start.sh
source .config/.install/dependencies.sh
source .config/.install/hyprland.sh
source .config/.install/paru.sh
source .config/.install/hyprland-packages.sh
source .config/.install/install-packages.sh
source .config/.install/wallpaper.sh
source .config/.install/display-manager.sh
source .config/.install/tty-login.sh
source .config/.install/install-dotfiles.sh
source .config/.install/config-folder.sh
source .config/.install/init-pywal.sh
source .config/.install/cleanup-homedir.sh
source .config/.install/hyprland-dotfiles.sh
source .config/.install/hyprland-entry.sh
source .config/.install/seclists.sh
source .config/.install/auto-cpufreq.sh
source .config/.install/systemd-boot.sh
source .config/.install/locales.sh
source .config/.install/nnn.sh
source .config/.install/supergfxd.sh
source .config/.install/button-layout.sh
source .config/.install/zsh.sh
source .config/.install/final-message.sh
