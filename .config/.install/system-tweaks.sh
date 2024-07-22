#!/bin/bash

clear
cat <<"EOF"
 ____            _                   _____                    _        
/ ___| _   _ ___| |_ ___ _ __ ___   |_   _|_      _____  __ _| | _____ 
\___ \| | | / __| __/ _ \ '_ ` _ \    | | \ \ /\ / / _ \/ _` | |/ / __|
 ___) | |_| \__ \ ||  __/ | | | | |   | |  \ V  V /  __/ (_| |   <\__ \
|____/ \__, |___/\__\___|_| |_| |_|   |_|   \_/\_/ \___|\__,_|_|\_\___/
       |___/                                                           

EOF

# Function to check and append a line to a file if not already present
append_if_not_exists() {
    local line="$1"
    local file="$2"
    
    # Create the file if it doesn't exist
    if [ ! -f "$file" ]; then
        sudo touch "$file"
        sudo chmod 644 "$file"
        echo "Created: $file"
    fi

    # Check for exact match in the file
    if grep -Fxq "$line" "$file"; then
        echo "Already present: $line"
    else
        echo "$line" | sudo tee -a "$file" > /dev/null
        echo "Added: $line"
    fi
}

# Prompt the user
read -p "Do you want to append performance tweaks to the system? (y/n) " answer
if [[ "$answer" != "y" ]]; then
    echo "No changes made."
    exit 0
fi

# Define tweaks to be added
sysctl_conf_tweaks=(
    "vm.vfs_cache_pressure=50"
    "vm.swappiness=20"
    "vm.dirty_background_ratio=15"
    "vm.dirty_ratio=40"
    "vm.oom_dump_tasks=0"
    "vm.oom_kill_allocating_task=1"
    "vm.overcommit_memory=1"
)

# Check and append tweaks to /etc/sysctl.conf
echo
for tweak in "${sysctl_conf_tweaks[@]}"; do
    append_if_not_exists "$tweak" "/etc/sysctl.conf"
done

# Special case for /etc/sysctl.d/99-splitlock.conf
special_tweak="kernel.split_lock_mitigate=0"
append_if_not_exists "$special_tweak" "/etc/sysctl.d/99-splitlock.conf"

echo
echo "Performance tweaks applied."

# Wait 2 sec before clear so user knows what happened
sleep 2
