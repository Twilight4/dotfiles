#!/bin/bash

# This scripts nukes you linux system
# Execute as root user

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

# Function to wipe a specified partition
wipe_partition() {
    local partition=$1
    echo "Wiping $partition..."
    dd if=/dev/urandom of=$partition bs=4M status=progress
}

# Wipe the /home directory
echo "Starting to wipe /home directory..."
home_partition=$(df /home | tail -1 | awk '{print $1}')
if [ -n "$home_partition" ]; then
    wipe_partition $home_partition
else
    echo "Could not determine the partition for /home"
    exit 1
fi

# Wipe the rest of the system
echo "Starting to wipe the rest of the system..."

# Get the root partition
root_partition=$(df / | tail -1 | awk '{print $1}')
if [ -z "$root_partition" ]; then
    echo "Could not determine the root partition"
    exit 1
fi

# Get all partitions except for /home and the root partition
partitions=$(lsblk -ln -o NAME,TYPE | grep "part$" | awk '{print "/dev/" $1}')
for partition in $partitions; do
    if [ "$partition" != "$home_partition" ] && [ "$partition" != "$root_partition" ]; then
        wipe_partition $partition
    fi
done

# Finally, wipe the root partition
wipe_partition $root_partition

echo "Wiping complete."
