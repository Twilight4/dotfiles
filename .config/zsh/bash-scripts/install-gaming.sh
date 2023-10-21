#!/bin/bash

# Installing lutris client
sudo pacman -S --noconfirm --needed lutris-git
# Installing drivers for Vulkan API - AMD GPUs
sudo pacman -S --noconfirm --needed lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader
# Installing Wine Dependencies
sudo pacman -S --noconfirm --needed wine-staging giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls \
mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error \
lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo \
sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama \
ncurses lib32-ncurses ocl-icd lib32-ocl-icd libxslt lib32-libxslt libva lib32-libva gtk3 \
lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader

# Try using CachyOS's package for esential gaming packages
#sudo pacman -S cachyos-gaming-meta

# Installing League of Legends via leagueoflegends-git
# Helper script for installing and running League of Legends on Linux: https://github.com/kyechou/leagueoflegends
# CachyOS guide for Gaming: https://wiki.cachyos.org/general_info/gaming/
# For support visit league of legends wiki - https://leagueoflinux.org/
