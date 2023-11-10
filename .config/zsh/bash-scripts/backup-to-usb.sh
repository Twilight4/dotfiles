#!/bin/sh

# backup home to usb
rsync -aAXvz --ignore-errors --delete --progress \
--exclude Downloads \
--exclude Documents/BlackmagicDesign \
--exclude GPUCache \
--exclude Music \
--exclude roms \
--exclude snap \
--exclude torrents \
--exclude Videos \
--exclude libvirt \
--exclude .nix-channels \
--exclude .nix-defexpr \
--exclude .nix-profile \
--exclude .config/xmonad \
--exclude .cache \
--exclude .dbus \
--exclude .mozilla \
--exclude .var \
--exclude .kodi \
--exclude .googleearth \
--exclude .local/share/flatpak \
/home/djwilcox /mnt/usb
