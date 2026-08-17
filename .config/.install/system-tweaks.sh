#!/usr/bin/env bash
# Sourced by install.sh — use `return`, not `exit`.

clear
cat <<"EOF"
 ____            _                   _____                    _
/ ___| _   _ ___| |_ ___ _ __ ___   |_   _|_      _____  __ _| | _____
\___ \| | | / __| __/ _ \ '_ ` _ \    | | \ \ /\ / / _ \/ _` | |/ / __|
 ___) | |_| \__ \ ||  __/ | | | | |   | |  \ V  V /  __/ (_| |   <\__ \
|____/ \__, |___/\__\___|_| |_| |_|   |_|   \_/\_/ \___|\__,_|_|\_\___/
       |___/

EOF

########################################################
# PERFORMANCE TWEAKS                                   #
########################################################
# Append a line to a file if not already present (exact match).
append_if_not_exists() {
    local line="$1"
    local file="$2"

    # Create the file if it doesn't exist
    if [[ ! -f $file ]]; then
        sudo touch "$file"
        sudo chmod 644 "$file"
        info "Created: $file"
    fi

    # Check for exact match in the file
    if grep -Fxq "$line" "$file"; then
        info "Already present: $line"
    else
        echo "$line" | sudo tee -a "$file" >/dev/null
        ok "Added: $line"
    fi
}

# Comment out a line if it exists
comment_out_line() {
    local pattern="$1"
    local file="$2"

    if grep -q "^${pattern}" "$file"; then
        sudo sed -i "s/^${pattern}/#${pattern}/" "$file"
        info "Commented out: $pattern"
    fi
}

# Uncomment a line if it exists
uncomment_line() {
    local pattern="$1"
    local file="$2"

    # Check if the line is commented out
    if grep -q "^#${pattern}" "$file"; then
        sudo sed -i "s/^#${pattern}/${pattern}/" "$file"
        info "Uncommented: ${pattern}"
    else
        info "Line not commented: ${pattern}"
    fi
}

# Insert a new line after a specific pattern
insert_after_pattern() {
    local pattern="$1"
    local new_line="$2"
    local file="$3"

    if grep -q "^${pattern}" "$file"; then
        sudo sed -i "/^${pattern}/a $new_line" "$file"
        info "Inserted: $new_line"
    fi
}

# Prompt the user
read -p "Do you want to append performance tweaks to the system (Recommended)? (y/n) " answer
if [[ $answer != "y" ]]; then
    info "No changes made."
    return 0
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
append_if_not_exists "kernel.split_lock_mitigate=0" "/etc/sysctl.d/99-splitlock.conf"

echo
ok "Performance tweaks applied in sysctl.conf file."

########################################################
# GRUB MENU                                            #
########################################################
# Prompt user to optimize GRUB config
echo
read -p "Do you want to optimize AMD CPU in the GRUB configuration (Recommended)? (y/n) " optimize_grub
echo
if [[ $optimize_grub == "y" ]]; then
    grub_file="/etc/default/grub"

    # Comment out existing GRUB_CMDLINE_LINUX_DEFAULT line and add new one below it
    comment_out_line "GRUB_CMDLINE_LINUX_DEFAULT=" "$grub_file"
    insert_after_pattern "#GRUB_CMDLINE_LINUX_DEFAULT=" 'GRUB_CMDLINE_LINUX_DEFAULT="zswap.compressor=zstd zswap.max_pool_percent=10 amd-pstate=active"' "$grub_file"

    # Uncomment specific GRUB settings if they exist
    uncomment_line 'GRUB_DISABLE_RECOVERY=true' "$grub_file"
    uncomment_line 'GRUB_DISABLE_SUBMENU=y' "$grub_file"

    # Prompt user to disable GRUB menu
    echo
    read -p "Do you want to disable the GRUB menu (not recommended if using snapshots/dual-booting)? (y/n) " disable_grub_menu
    if [[ $disable_grub_menu == "y" ]]; then
        comment_out_line "GRUB_TIMEOUT=" "$grub_file"
        insert_after_pattern "#GRUB_TIMEOUT=" "GRUB_TIMEOUT=0" "$grub_file"
    fi

    # Update GRUB configuration
    echo
    info "Updating GRUB configuration..."
    sudo update-grub
    echo
    ok "GRUB configuration optimized."
else
    info "No changes made to GRUB configuration."
fi
