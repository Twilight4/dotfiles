#!/bin/bash

# This script nukes your Linux system.
# The script doesn't touch other than Linux partitions.
# Execute as root user.

## Breakdown
# 1. The script first checks if the /home directory is stored in a different partition, then wipes it first (skips if it is not).
# 2. The script checks and wipes all other Linux partitions except for /home and /root partition.
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

# Function to prompt for confirmation
confirm() {
    read -p "This script will completely wipe your Linux system. Are you sure you want to proceed? (yes/no): " response
    case "$response" in
        [yY]|[yY][eE][sS])
            echo "Bailing out, you are on your own. Good luck."
            ;;
        *)
            echo "Script execution aborted."
            exit 1
            ;;
    esac
}

# Prompt for confirmation
confirm

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
echo "Wiping all other Linux partitions..."
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
