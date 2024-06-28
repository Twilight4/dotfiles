#!/bin/bash

# Check if the file exists
if [ -f ~/.nobility/vars/RHOST ]; then
  # Check if the file is empty
  if [ -s ~/.nobility/vars/RHOST ]; then
    # Read the content of the file
    RHOST_CONTENT=$(cat ~/.nobility/vars/RHOST)
    # Use notify-send to display the content
    notify-send -t 3000 "RHOST IP Address:" "$RHOST_CONTENT"
    echo "$RHOST_CONTENT" | wl-copy -n
  else
    # Use notify-send to display a message if the file is empty
    notify-send -t 3000 "RHOST is empty"
  fi
else
  # Use notify-send to display an error message if the file doesn't exist
  notify-send -t 3000 "File ~/.nobility/vars/RHOST does not exist."
fi
