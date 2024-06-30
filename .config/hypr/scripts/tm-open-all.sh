#!/bin/bash

############################################
# ASCIIQUARIUM                             #
############################################
# Function to check if 'kitty' process is running
is_kitty_running() {
	hyprctl clients | grep 'asciiquarium' >/dev/null
}

# Focus on ws "7" and spawn kitty if it's not running, else only focus
if ! is_kitty_running; then
    # Spawn 'footclient' only if it was not running
    hyprctl dispatch exec 'kitty -o -T asciiquarium --class asciiquarium -e asciiquarium --transparent'
else
    hyprctl dispatch focuswindow '^asciiquarium$'
fi

# Function to check if 'kitty' process is running
is_kitty_running() {
	hyprctl clients | grep 'cava' >/dev/null
}


############################################
# CAVA                                     #
############################################
# Focus on ws "7" and spawn kitty if it's not running, else only focus
if ! is_kitty_running; then
    # Spawn 'footclient' only if it was not running
    hyprctl dispatch exec 'kitty -o -T cava --class cava -e cava'
else
    hyprctl dispatch focuswindow '^cava$'
fi

# Function to check if 'kitty' process is running
is_kitty_running() {
	hyprctl clients | grep 'clock' >/dev/null
}


############################################
# CLOCK                                    #
############################################
# Focus on ws "7" and spawn kitty if it's not running, else only focus
if ! is_kitty_running; then
    # Spawn 'footclient' only if it was not running
    hyprctl dispatch exec 'kitty -o -T clock --class clock -e tty-clock -c -C 6 -r -s -f "%A, %B, %d"'
else
    hyprctl dispatch focuswindow '^clock$'
fi


############################################
# CMATRIX                                  #
############################################
# Function to check if 'kitty' process is running
is_kitty_running() {
	hyprctl clients | grep 'cmatrix -a' >/dev/null
}

# Focus on ws "7" and spawn kitty if it's not running, else only focus
if ! is_kitty_running; then
    # Spawn 'footclient' only if it was not running
    hyprctl dispatch exec 'kitty -o -T cmatrix --class cmatrix -e cmatrix'
else
    hyprctl dispatch focuswindow '^cmatrix$'
fi


############################################
# MUSIKCUBE                                #
############################################
# Function to check if 'kitty' process is running
is_kitty_running() {
	hyprctl clients | grep 'musikcube' >/dev/null
}

# Focus on ws "7" and spawn kitty if it's not running, else only focus
if ! is_kitty_running; then
    # Spawn 'footclient' only if it was not running
    hyprctl dispatch exec 'kitty -o -T musikcube --class musikcube -e musikcube'
else
    hyprctl dispatch focuswindow '^musikcube$'
fi


############################################
# PIPES                                    #
############################################
# Function to check if 'kitty' process is running
is_kitty_running() {
	hyprctl clients | grep 'pipes' >/dev/null
}

# Focus on ws "7" and spawn kitty if it's not running, else only focus
if ! is_kitty_running; then
    # Spawn 'footclient' only if it was not running
    hyprctl dispatch exec 'kitty -o -T pipes --class pipes -e ~/.config/zsh/bash-scripts/pipes'
else
    hyprctl dispatch focuswindow '^pipes$'
fi


############################################
# RAIN                                     #
############################################
# Function to check if 'kitty' process is running
is_kitty_running() {
	hyprctl clients | grep 'rain' >/dev/null
}

# Focus on ws "7" and spawn kitty if it's not running, else only focus
if ! is_kitty_running; then
    # Spawn 'footclient' only if it was not running
    hyprctl dispatch exec 'kitty -o -T rain --class rain -e ~/.config/zsh/bash-scripts/rain'
else
    hyprctl dispatch focuswindow '^rain$'
fi


############################################
# FASTFETCH                                #
############################################
# Function to check if 'kitty' process is running
is_kitty_running() {
	hyprctl clients | grep 'fetch' >/dev/null
}

# Spawn 'kitty' if it's not running, else only focus
if ! is_kitty_running; then
    hyprctl dispatch exec 'kitty -o --hold -T fetch --class fetch -e fastfetch --kitty ~/pictures/screenshots/Patrick-Bateman-Profile-Pic_600x600.jpg'
else
    hyprctl dispatch focuswindow '^fetch$'
fi


############################################
# FIREPLACE                                #
############################################
# Function to check if 'kitty' process is running
is_kitty_running() {
	hyprctl clients | grep 'fireplace' >/dev/null
}

# Spawn 'kitty' if it's not running, else only focus
if ! is_kitty_running; then
    hyprctl dispatch exec 'kitty -o --class fireplace -T fireplace -e fireplace'
else
    hyprctl dispatch focuswindow '^fireplace$'
fi


############################################
# WEBCAM                                   #
############################################
# Function to check if 'ffplay' process is running
is_webcam_running() {
	hyprctl clients | grep 'ffplay' >/dev/null
}

# Spawn webcam if it's not running, else only focus
if ! is_webcam_running; then
    # Spawn 'webcam.sh' only if it was not running
    hyprctl dispatch exec '~/.config/.local/bin/webcam.sh'
else
    hyprctl dispatch focuswindow '^ffplay$'
fi
