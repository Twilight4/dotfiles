#!/bin/bash

ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
hwclock --systohc
sed -i '178s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "archlinux" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 archlinux.localdomain archlinux" >> /etc/hosts
echo root:123 | chpasswd
useradd -m -G wheel -s /bin/bash twilight
echo twilight:123 | chpasswd

pacman -S grub efibootmgr networkmanager
systemctl enable NetworkManager
# pacman -S --noconfirm xf86-video-amdgpu
grub-install --target=x86_64-efi --efi-directory=/efi/ --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
curl https://raw.githubusercontent.com/Twilight4/arch-install/master/sudoers > /etc/sudoers
curl https://raw.githubusercontent.com/Twilight4/arch-install/master/pacman.conf > /etc/pacman.conf
pacman -Sy

printf "\e[1;32mDone! Type exit, umount -R /mnt and poweroff.\e[0m"
