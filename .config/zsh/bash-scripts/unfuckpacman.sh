#!/bin/bash

sudo rm -rf /etc/pacman.d/gnupg/
sudo pacman-key --init
sudo pacman-key --populate

# CachyOS keyring
sudo pacman-key --recv-keys F3B607488DB35A47 --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key F3B607488DB35A47
# AthenaOS keyring
sudo pacman-key --recv-keys A3F78B994C2171D5 --keyserver keys.openpgp.org
sudo pacman-key --lsign A3F78B994C2171D5
sudo pacman -Syy

echo 'Done - Press enter to exit; read _"'
