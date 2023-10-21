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

# Installing League of Legends
### Option 1: Installing League of Legends using lutris
#1. `./install-lutris.sh` 
#2. Launch lutris and log in
#3. Search for Leauge of Legends, by clicking at the "+" icon and choose Standard version for your region
#### Caveats
#- There are two downloads one after the other: the initial client download and the Riot client download. Wait for both downloads to finish.
#- Do not enter your login details and login or click play. Instead, just quit the launcher when the two downloads have finished in btop search for: **league** and kill the process.
### Option 2: Installing League of Legends via leagueoflegends-git
#- Helper script for installing and running League of Legends on Linux: https://github.com/kyechou/leagueoflegends
#- CachyOS guide for Gaming: https://wiki.cachyos.org/general_info/gaming/
# For support visit league of legends wiki - https://leagueoflinux.org/

# If you have critical errors in games try this command
#- `sudo sh -c 'sysctl -w abi.vsyscall32=0' && sudo sysctl -w abi.vsyscall32=0`

### Game or client resolution or it is stuck at the lowest resolution
#-  Right Click League of Legends
#-  Select `Configure`
#-  Select `Runner options`
#-  Enable `Windowed (virtual desktop)`
#-  Change `Virtual desktop resolution` to the size of your monitor
#-  Launch the game and in graphics settings change `Window mode` to `Borderless`

### Gamemode errors
#If you see either one of: 
#- `ERROR: ld.so: object '/usr/$LIB/libgamemodeauto.so.0' from LD_PRELOAD cannot be preloaded (cannot open shared object file): ignored.` or 
#- `ERROR: ld.so: object ‘libgamemodeauto.so.0’ from LD_PRELOAD cannot be preloaded (wrong ELF class: ELFCLASS64): ignored.` in your logs
#    - This is a known error and does not have any effect on the performance or ability to play games. It can safely be ignored, and is not considered the cause of inability to play League.
