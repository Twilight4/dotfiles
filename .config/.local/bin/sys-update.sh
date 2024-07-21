#!/bin/bash

# Function to print colored messages
print_colored() {
    local color=$1
    local message=$2
    tput setaf $color
    echo -ne "$message"
    tput sgr0
}

# Define colors
RED=1
GREEN=2
YELLOW=3
CYAN=6

# Print welcome message
print_colored $CYAN "This script will update your system using paru.\n"

# Ask for user confirmation
print_colored $YELLOW "Do you want to proceed with the system update? (y/n): "
read -r response

if [[ "$response" == "y" ]]; then
    print_colored $GREEN "\nStarting the system update...\n"
    paru -Syu
    echo
    print_colored $GREEN "System update completed.\n"
else
    print_colored $RED "\nSystem update aborted by the user.\n"
fi
