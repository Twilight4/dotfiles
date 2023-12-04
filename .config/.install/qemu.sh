#!bin/bash

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
        [Yy]* ) return 0;;
        [Nn]* ) return 1;;
        * ) echo "Invalid input. Please answer yes or no."; return 1;;
    esac
}

# Ask the user if they want to install QEMU
install_qemu=false
if prompt_yes_no "Do you want to install QEMU and related packages?"; then
    # Install all necessary packages
    sudo pacman -S virt-manager virt-viewer qemu-base edk2-ovmf ebtables \
    dnsmasq vde2 ebtables bridge-utils openbsd-netcat libguestfs libvirt
    
    paru -S qemu-arch-extra-git

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
	if curl -LJO https://raw.githubusercontent.com/Twilight4/arch-setup/main/config-files/libvirtd.conf && sudo mv libvirtd.conf /etc/libvirtd.conf; then
		echo "/etc/libvirtd.conf file written successfully"
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
	
	# Switch to the libvirt group (won't work)
	#newgrp libvirt
	
	# Additional message
	echo "User is now in the libvirt group."


    # Enable nested virtualization (optional)
    if prompt_yes_no "Do you want to enable nested virtualization?"; then
        sudo modprobe -r kvm_intel
        sudo modprobe kvm_intel nested=1
        echo "options kvm-intel nested=1" | sudo tee /etc/modprobe.d/kvm-intel.conf
    fi


    # Verify nested virtualization
    echo "Verifying nested virtualization:"
    systool -m kvm_intel -v | grep nested
    cat /sys/module/kvm_intel/parameters/nested
fi
