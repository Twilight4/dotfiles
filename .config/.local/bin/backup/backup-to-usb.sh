#!/bin/sh

# backup home to usb
rsync -aAXvz --ignore-errors --delete --progress \
	--exclude downloads \
	--exclude music \
	--exclude videos \
	--exclude .config \
	--exclude .cache \
	/home/$USER /mnt/usb
