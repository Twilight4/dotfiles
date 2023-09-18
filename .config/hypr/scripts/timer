#!/bin/bash

# Ask the user to specify the countdown time
read -p "Enter the countdown time (HH:MM:SS format): " input_time

# Use IFS (Internal Field Separator) to split the input_time into hours, minutes, and seconds
IFS=':' read -r hours minutes seconds <<< "$input_time"

# Calculate the total seconds
total_seconds=$((hours*3600 + minutes*60 + seconds))

# Display initial message
echo "Counting down $hours hours, $minutes minutes, and $seconds seconds..."

# Loop through the countdown
for ((i=total_seconds; i>0; i--)); do
    printf "\rTime left: %02d:%02d:%02d" $((i/3600)) $(((i%3600)/60)) $((i%60))
    sleep 1
done

# Display a message when the timer is done
echo -e "\nTime's up!"

# Send a notification
notify-send "Timer Finished" "The countdown has completed."
