#!/bin/bash

cat <<"EOF"
  __ _  ___ _ __ ___  _   _ 
 / _` |/ _ \ '_ ` _ \| | | |
| (_| |  __/ | | | | | |_| |
 \__, |\___|_| |_| |_|\__,_|
    |_|                     
EOF

# Function to prompt user with yes/no question
prompt_yes_no() {
	read -p "$1 (y/n): " yn
	case $yn in
	[Yy]*) return 0 ;;
	[Nn]*) return 1 ;;
	*)
		echo "Invalid input. Please answer yes or no."
		return 1
		;;
	esac
}

# Ask the user if they want to install QEMU
install_qemu=false
if prompt_yes_no "Do you want to install QEMU and related packages?"; then
	# Install all necessary packages
	sudo pacman -S --needed virt-manager virt-viewer qemu-base edk2-ovmf dnsmasq vde2 ebtables bridge-utils openbsd-netcat libguestfs libvirt

	install_qemu=true
fi

# Proceed only if the user chose to install QEMU
if $install_qemu; then

	# Enable libvirt daemon
	if ! sudo systemctl is-enabled --quiet libvirtd.service; then
		sudo systemctl enable --now libvirtd.service
		echo "libvirtd.service enabled and started successfully"
	else
		echo "libvirtd.service is already enabled"
	fi

	# Start and autostart network bridge
	sudo virsh net-start default
	sudo virsh net-autostart default

	# Enable normal user account to use KVM
	if curl -LJO https://raw.githubusercontent.com/Twilight4/arch-setup/main/config-files/libvirtd.conf && sudo mv libvirtd.conf /etc/libvirt/libvirtd.conf; then
		echo "/etc/libvirt/libvirtd.conf file written successfully"
	else
		echo "Error: Unable to download or move the file"
	fi

	# Add current user to kvm and libvirt groups
	sudo usermod -a -G kvm $(whoami)
	sudo usermod -a -G libvirt $(whoami)
	sudo usermod -a -G libvirt-qemu $(whoami)

	# Check if the user is added to the groups
	if groups | grep -q "\bkvm\b" && groups | grep -q "\blibvirt\b" && groups | grep -q "\blibvirt-qemu\b"; then
		echo "User is added to kvm, libvirt, and libvirt-qemu groups."
	else
		echo "User added to kvm and libvirt groups"
	fi

fi
