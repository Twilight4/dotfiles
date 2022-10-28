# THIS IS GONNA BE MANUAL ARCHINSTALL SCRIPT WHICH WILL BE MOUNTED INTO ISO, THAT I'M DEVELOPING FOR MYSELF, DONT USE IT

#!/bin/bash

ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
hwclock --systohc
sed -i '178s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "archlinux" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 arch.localdomain arch" >> /etc/hosts
echo root:123 | chpasswd

timedatectl set-ntp true

pacman -S grub networkmanager xdg-user-dirs pipewire virtualbox-guest-utils-nox

# pacman -S --noconfirm xf86-video-amdgpu

mkdir /boot/efi
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB

grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager
systemctl enable vboxservice.service

useradd -G wheel -m twilight
echo twilight:123 | chpasswd

curl https://raw.githubusercontent.com/Twilight4/arch-install/master/sudoers > /etc/sudoers

printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"
