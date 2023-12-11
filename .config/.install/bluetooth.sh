#!/bin/bash

cat <<"EOF"
 _     _            _              _   _     
| |__ | |_   _  ___| |_ ___   ___ | |_| |__  
| '_ \| | | | |/ _ \ __/ _ \ / _ \| __| '_ \ 
| |_) | | |_| |  __/ || (_) | (_) | |_| | | |
|_.__/|_|\__,_|\___|\__\___/ \___/ \__|_| |_|
EOF

# Function to check if a package is installed
package_installed() {
    for package in "$@"; do
        pacman -Qi "$package" &> /dev/null || return 1
    done
    return 0
}

# Function to prompt user with yes/no question
ask_yes_no() {
    read -r -p "$1 (y/n): " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# List of Bluetooth packages
bluetooth_packages=("bluez" "bluez-tools" "bluez-utils" "blueberry")

# Check if any of the Bluez packages are not installed
if ! package_installed "${bluetooth_packages[@]}"; then
    echo "Bluetooth packages are not installed."

    # Ask user if they want to install Bluetooth packages
    if ask_yes_no "Do you want to install Bluetooth packages"; then
        sudo pacman -S "${bluetooth_packages[@]}"
        echo "Bluetooth packages installed successfully."
    else
        echo "Bluetooth installation skipped."
        exit 0
    fi
else
    echo "Bluetooth packages are already installed."
fi

# Check if Bluetooth service is enabled and start if not
if ! systemctl is-active --quiet bluetooth; then
    sudo systemctl enable --now bluetooth
    echo "Bluetooth service enabled and started successfully."
else
    echo "Bluetooth service is already enabled and running."
fi
