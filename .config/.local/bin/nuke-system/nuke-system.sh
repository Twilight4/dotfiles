#!/bin/bash

# This scripts nukes your linux system.
# The script doesn't touch other than linux partitions.
# Execute as root user.

## Breakdown
# 1. The script first checks if the /home directory is stored in a different partition, then wipes it first (skips if it is not).
# 2. The script checks and wipes all other linux partitions except for /home and /root partition.
# 3. The script wipes the /root partition.

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

# Function to check if a partition is a Linux partition
is_linux_partition() {
    local partition=$1
    local fstype=$(lsblk -no FSTYPE $partition)

    case $fstype in
        ext2|ext3|ext4|btrfs|xfs|swap) return 0 ;;
        *) return 1 ;;
    esac
}

# 1. Wipe the /home partition
echo "Wiping /home partition..."
home_partition=$(df /home | tail -1 | awk '{print $1}')
if [ -n "$home_partition" ]; then
    if is_linux_partition $home_partition; then
        wipe_partition $home_partition
    else
        echo "The /home partition ($home_partition) is not a Linux partition."
        exit 1
    fi
else
    echo "Could not determine the partition for /home"
    exit 1
fi

# Get the /root partition
root_partition=$(df / | tail -1 | awk '{print $1}')
if [ -z "$root_partition" ]; then
    echo "Could not determine the root partition"
    exit 1
fi

# 2. Wipe all partitions except for /home and the /root partition
partitions=$(lsblk -ln -o NAME,TYPE | grep "part$" | awk '{print "/dev/" $1}')
for partition in $partitions; do
    if [ "$partition" != "$home_partition" ] && [ "$partition" != "$root_partition" ]; then
        if is_linux_partition $partition; then
            wipe_partition $partition
        else
            echo "Skipping non-Linux partition $partition."
        fi
    fi
done

# 3. Wipe the root partition
wipe_partition $root_partition

echo "Wiping complete."
