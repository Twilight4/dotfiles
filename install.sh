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
source .config/.install/rsync.sh
source .config/.install/backup.sh
source .config/.install/preparation.sh
source .config/.install/profile.sh
source .config/.install/hyprland.sh
source .config/.install/paru.sh
source .config/.install/hyprland-packages.sh
source .config/.install/install-packages.sh
source .config/.install/pywal.sh
source .config/.install/wallpaper.sh
source .config/.install/disabledm.sh
source .config/.install/issue.sh
source .config/.install/restore.sh
source .config/.install/setup.sh
source .config/.install/copy.sh
source .config/.install/config-folder.sh
source .config/.install/init-pywal.sh
source .config/.install/hyprland-dotfiles.sh
source .config/.install/zsh.sh
source .config/.install/done.sh
