#!/bin/bash

cat <<"EOF"
 _   _                                                 
| | | |___  ___ _ __    __ _ _ __ ___  _   _ _ __  ___ 
| | | / __|/ _ \ '__|  / _` | '__/ _ \| | | | '_ \/ __|
| |_| \__ \  __/ |    | (_| | | | (_) | |_| | |_) \__ \
 \___/|___/\___|_|     \__, |_|  \___/ \__,_| .__/|___/
                       |___/                |_|        
EOF

groups_to_create=(
    "plugdev"
    "autologin"
    "video"
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
