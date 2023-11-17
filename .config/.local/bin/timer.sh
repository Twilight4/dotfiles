#!/bin/bash

# Clear the screen
clear

# Ask the user to specify the countdown time
read -p "Enter the countdown time (HH:MM:SS format): " input_time
#echo -e "\033[A\033[K"  # Clear the previous line

# Use IFS (Internal Field Separator) to split the input_time into hours, minutes, and seconds
IFS=':' read -r hours minutes seconds <<< "$input_time"

# Calculate the total seconds
total_seconds=$((hours*3600 + minutes*60 + seconds))

# Ask the user for notification interval in minutes
read -p "Enter the notification interval in minutes (enter 0 for no notifications): " notification_interval
#echo -e "\033[A\033[K"  # Clear the previous line

# Convert notification interval to seconds, or set it to 0 if user specified 0 or nothing
notification_interval=$((notification_interval * 60))

# Show a notification that the countdown has started
notify-send "Countdown Started" "The countdown has begun."

# Store the starting time
start_time=$(date +%s)

# Display initial message
echo "Counting down $hours hours, $minutes minutes, and $seconds seconds..."

# Loop through the countdown
for ((i=total_seconds; i>0; i--)); do
    # Redirect output to a variable and then echo for piping through lolcat
    output=$(printf "\rTime left: %02d:%02d:%02d" $((i/3600)) $(((i%3600)/60)) $((i%60)))
    echo -n "$output" | lolcat
    
    # Check if it's time to display a notification
    current_time=$(date +%s)
    elapsed_seconds=$((current_time - start_time))
    if (( notification_interval != 0 )) && (( elapsed_seconds % notification_interval == 0 )) && (( elapsed_seconds != 0 )); then
        elapsed_minutes=$((elapsed_seconds / 60))
        echo -n "Time Elapsed: $elapsed_minutes minute(s)" | lolcat
        notify-send "Time Elapsed" "Elapsed Time: $elapsed_minutes minute(s)"
    fi
    
    sleep 1
done

# Display the specified countdown time in a notification
notify-send "Countdown Completed" "Countdown Time: $hours hours, $minutes minutes, and $seconds seconds."
