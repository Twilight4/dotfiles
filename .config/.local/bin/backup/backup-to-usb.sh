#!/bin/sh

# backup home to usb
rsync -aAXvz --ignore-errors --delete --progress \
	--exclude downloads \
	--exclude music \
	--exclude torrents \
	--exclude videos \
	--exclude .config \
	--exclude .cache \
	--exclude .floorp \
	/home/$USER /mnt/usb
