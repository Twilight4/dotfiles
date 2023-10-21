#!/bin/bash

sudo rm -rf /etc/pacman.d/gnupg/
sudo pacman-key --init
sudo pacman-key --populate

sudo pacman-key --recv-keys F3B607488DB35A47 --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key F3B607488DB35A47

echo 'Done - Press enter to exit; read _"'
