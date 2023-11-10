#!/bin/sh

# backup home to usb
rsync -aAXvz --ignore-errors --delete --progress \
--exclude downloads \
--exclude documents/BlackmagicDesign \
--exclude GPUCache \
--exclude music \
--exclude roms \
--exclude snap \
--exclude torrents \
--exclude videos \
--exclude libvirt \
--exclude .config/xmonad \
--exclude .cache \
--exclude .dbus \
--exclude .mercury \
--exclude .var \
--exclude .googleearth \
--exclude .local/share/flatpak \
/home/twilight /mnt/usb
