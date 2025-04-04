#!/bin/bash

clear
cat <<"EOF"
 ____        _   _                  
| __ ) _   _| |_| |_ ___  _ __  ___ 
|  _ \| | | | __| __/ _ \| '_ \/ __|
| |_) | |_| | |_| || (_) | | | \__ \
|____/ \__,_|\__|\__\___/|_| |_|___/

EOF
                                    
# Prompt the user
read -p "This will remove the GTK button layout. Press any key to continue or Ctrl+C to exit..." -n 1 -s
echo

# Define the desired button layout value (remove buttons - none)
desired_button_layout=":"

# Get the current button layout value using gsettings
current_button_layout=$(gsettings get org.gnome.desktop.wm.preferences button-layout)

# Compare the current value with the desired value using an if statement
if [ "$current_button_layout" != "$desired_button_layout" ]; then
    # If they don't match, update the button layout using the gsettings command
    gsettings set org.gnome.desktop.wm.preferences button-layout "$desired_button_layout"
    echo
    echo "Button layout has been updated."
else
    # If they match, display a message indicating that the value is already as desired
    echo
    echo "Button layout is already set as desired."
fi

echo
echo "Button layout update canceled by user."

# Wait 2 sec before clear so user knows what happened
sleep 2
