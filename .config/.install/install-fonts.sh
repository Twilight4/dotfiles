#!/bin/bash

clear
cat <<"EOF"
 _____           _       
|  ___|__  _ __ | |_ ___ 
| |_ / _ \| '_ \| __/ __|
|  _| (_) | | | | |_\__ \
|_|  \___/|_| |_|\__|___/

EOF

# Confirmation prompt
read -p "Do you want to install fonts? (y/n) " answer
case ${answer:0:1} in
    y|Y )
        # Jetbrains nerd font
        echo
        echo "Installing fonts..."
        echo "Downloading and Extracting Jetbrains Mono Nerd Font..."
        DOWNLOAD_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"
        # Maximum number of download attempts
        MAX_ATTEMPTS=3
        for ((ATTEMPT = 1; ATTEMPT <= MAX_ATTEMPTS; ATTEMPT++)); do
            curl -OL "$DOWNLOAD_URL"&& break
            echo "Download attempt $ATTEMPT failed. Retrying in 2 seconds..."
            sleep 2
        done

        # Check if the JetBrainsMono folder exists and delete it if it does
        if [ -d ~/.config/.local/share/fonts/JetBrainsMonoNerd ]; then
            rm -rvf ~/.config/.local/share/fonts/JetBrainsMono
        fi

        mkdir -pv ~/.config/.local/share/fonts/JetBrainsMono

        # Extract the new files into the JetBrainsMono folder and log the output
        tar -xJkf JetBrainsMono.tar.xz -C ~/.config/.local/share/fonts/JetBrainsMono


        # Meslo nerd font
        echo
        echo "Downloading and Extracting Meslo Nerd Font..."
        DOWNLOAD_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.tar.xz"
        # Maximum number of download attempts
        MAX_ATTEMPTS=3
        for ((ATTEMPT = 1; ATTEMPT <= MAX_ATTEMPTS; ATTEMPT++)); do
            curl -OL "$DOWNLOAD_URL" && break
            echo "Download attempt $ATTEMPT failed. Retrying in 2 seconds..."
            sleep 2
        done

        # Check if the Meslo folder exists and delete it if it does
        if [ -d ~/.config/.local/share/fonts/Meslo ]; then
            rm -rfv ~/.config/.local/share/fonts/Meslo
        fi

        mkdir -pv ~/.config/.local/share/fonts/Meslo

        # Extract the new files into the Meslo folder and log the output
        tar -xJkf Meslo.tar.xz -C ~/.config/.local/share/fonts/Meslo

        # Update font cache and log the output
        fc-cache -v
        ;;
    * )
        echo "Skipping fonts installation..."
        ;;
esac

# Wait 2 sec before clear so user knows what happened
sleep 2
