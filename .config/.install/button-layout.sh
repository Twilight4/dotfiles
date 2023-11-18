#!/bin/bash

cat <<"EOF"
 _           _   _                  
| |__  _   _| |_| |_ ___  _ __  ___ 
| '_ \| | | | __| __/ _ \| '_ \/ __|
| |_) | |_| | |_| || (_) | | | \__ \
|_.__/ \__,_|\__|\__\___/|_| |_|___/
EOF
                                    
read -p "Do you want to remove the GTK button layout? (y/n): " update_layout_choice

if [[ "$update_layout_choice" =~ ^[Yy]$ ]]; then
    # Define the desired button layout value (remove buttons - none)
    desired_button_layout=":"

    # Get the current button layout value using gsettings
    current_button_layout=$(gsettings get org.gnome.desktop.wm.preferences button-layout)

    # Compare the current value with the desired value using an if statement
    if [ "$current_button_layout" != "$desired_button_layout" ]; then
        # If they don't match, update the button layout using the gsettings command
        gsettings set org.gnome.desktop.wm.preferences button-layout "$desired_button_layout"
        # Enable transparency in emacs - will move it later
        sed -i '/;(add-to-list.*For all new frames henceforth/s/;//' your_file_name
        echo "Button layout has been updated."
    else
        # If they match, display a message indicating that the value is already as desired
        echo "Button layout is already set as desired."
    fi
else
    echo "Button layout update canceled by user."
fi
