#!/usr/bin/env bash
# Orchestrator: sources every install module in order. Modules run in THIS
# shell, so strict mode here applies everywhere — any failing module command
# aborts the whole install instead of leaving silent partial state.
set -euo pipefail

# Deploy source: exported by setup.sh, default when install.sh is run directly.
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
export DOTFILES_DIR

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

# Fail fast on missing sudo rather than mid-chain with partial state.
sudo -v || { echo "This installation requires sudo privileges. Aborting..."; exit 1; }

################
# Installation #
################
source "$DOTFILES_DIR/.config/.install/library.sh"
source "$DOTFILES_DIR/.config/.install/confirm-start.sh"
source "$DOTFILES_DIR/.config/.install/install-hypr-packages.sh"
source "$DOTFILES_DIR/.config/.install/system-tweaks.sh"
source "$DOTFILES_DIR/.config/.install/cleanup-homedir.sh"
source "$DOTFILES_DIR/.config/.install/wallpaper.sh"
source "$DOTFILES_DIR/.config/.install/display-manager.sh"
source "$DOTFILES_DIR/.config/.install/install-fonts.sh"
source "$DOTFILES_DIR/.config/.install/install-dotfiles.sh"
source "$DOTFILES_DIR/.config/.install/zsh.sh"
source "$DOTFILES_DIR/.config/.install/nvchad.sh"
source "$DOTFILES_DIR/.config/.install/fzf.sh"
source "$DOTFILES_DIR/.config/.install/auto-cpufreq.sh"
source "$DOTFILES_DIR/.config/.install/enable-services.sh"
source "$DOTFILES_DIR/.config/.install/locales.sh"
source "$DOTFILES_DIR/.config/.install/prompt-reboot.sh"
