#!/bin/bash

cat <<"EOF"
  __             _       
 / _| ___  _ __ | |_ ___ 
| |_ / _ \| '_ \| __/ __|
|  _| (_) | | | | |_\__ \
|_|  \___/|_| |_|\__|___/
                         
EOF

# Confirmation prompt
read -p "Do you want to install fonts? (y/n) " answer
case ${answer:0:1} in
    y|Y )
        # Installation of main components
        printf "\n%s - Installing fonts.... \n"

        # Jetbrains nerd font
        printf "\n%s - Downloading and Extracting Jetbrains Mono Nerd Font.... \n" "${NOTE}"
        DOWNLOAD_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"
        # Maximum number of download attempts
        MAX_ATTEMPTS=3
        for ((ATTEMPT = 1; ATTEMPT <= MAX_ATTEMPTS; ATTEMPT++)); do
            curl -OL "$DOWNLOAD_URL" 2>&1 | tee -a "$LOG" && break
            echo "Download attempt $ATTEMPT failed. Retrying in 2 seconds..." 2>&1 | tee -a "$LOG"
            sleep 2
        done

        # Check if the JetBrainsMono folder exists and delete it if it does
        if [ -d ~/.config/.local/share/fonts/JetBrainsMonoNerd ]; then
            rm -rf ~/.config/.local/share/fonts/JetBrainsMono 2>&1 | tee -a "$LOG"
        fi

        mkdir -p ~/.config/.local/share/fonts/JetBrainsMono

        # Extract the new files into the JetBrainsMono folder and log the output
        tar -xJkf JetBrainsMono.tar.xz -C ~/.config/.local/share/fonts/JetBrainsMono 2>&1 | tee -a "$LOG"


        # Meslo nerd font
        printf "\n%s - Downloading and Extracting Meslo Nerd Font.... \n" "${NOTE}"
        DOWNLOAD_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.tar.xz"
        # Maximum number of download attempts
        MAX_ATTEMPTS=3
        for ((ATTEMPT = 1; ATTEMPT <= MAX_ATTEMPTS; ATTEMPT++)); do
            curl -OL "$DOWNLOAD_URL" 2>&1 | tee -a "$LOG" && break
            echo "Download attempt $ATTEMPT failed. Retrying in 2 seconds..." 2>&1 | tee -a "$LOG"
            sleep 2
        done

        # Check if the Meslo folder exists and delete it if it does
        if [ -d ~/.config/.local/share/fonts/Meslo ]; then
            rm -rf ~/.config/.local/share/fonts/Meslo 2>&1 | tee -a "$LOG"
        fi

        mkdir -p ~/.config/.local/share/fonts/Meslo

        # Extract the new files into the Meslo folder and log the output
        tar -xJkf Meslo.tar.xz -C ~/.config/.local/share/fonts/Meslo 2>&1 | tee -a "$LOG"


        # Update font cache and log the output
        fc-cache -v 2>&1 | tee -a "$LOG"

        clear
        ;;
    * )
        echo "Font installation skipped."
        ;;
esac
