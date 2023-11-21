#!/bin/bash

groups_to_create=(
    "plugdev"
    "autologin"
    "libvirt"
    "libvirt-qemu"
    "video"
    "kvm"
    "input"
    "disk"
    "mpd"
)

username=$(whoami)

# Create groups if they don't exist
for group in "${groups_to_create[@]}"; do
    grep -q "^$group:" /etc/group || sudo groupadd "$group"
done

# Add the user to the groups
for group in "${groups_to_create[@]}"; do
    sudo usermod -aG "$group" "$username"
done

echo "User $username added to the following groups:"
printf "%s\n" "${groups_to_create[@]}"
