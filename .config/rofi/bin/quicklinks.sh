#!/bin/bash

# Theme Elements
list_col='1'
list_row='6'

# Options
option_1=" Google"
option_2=" Proton Mail"
option_3=" Youtube"
option_4=" Github"
option_5=" Reddit"
option_6=" Twitter"

# Rofi CMD
rofi_cmd() {
	rofi \
    -theme-str "listview {columns: $list_col; lines: $list_row;}" \
		-theme-str 'textbox-prompt-colon {str: " ";}' \
		-dmenu \
    -replace \
		-markup-rows \
    -config ~/.config/rofi/configs/config-compact.rasi
}

# Function to get search query using Rofi
get_search_query() {
  echo -n | rofi -dmenu -p "Search Google:" -theme-str 'textbox-prompt-colon {str: " ";}' -config ~/.config/rofi/configs/config-compact1.rasi
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5\n$option_6" | rofi_cmd
}

# Execute Command
run_cmd() {
	if [[ "$1" == '--opt1' ]]; then
  query=$(get_search_query)
  if [ -z "$query" ]; then
    xdg-open "https://www.google.com" &
  else
    xdg-open "https://www.google.com/search?q=$query" &
  fi
	elif [[ "$1" == '--opt2' ]]; then
		xdg-open 'https://mail.google.com/'
	elif [[ "$1" == '--opt3' ]]; then
		xdg-open 'https://www.youtube.com/'
	elif [[ "$1" == '--opt4' ]]; then
		xdg-open 'https://www.github.com/'
	elif [[ "$1" == '--opt5' ]]; then
		xdg-open 'https://www.reddit.com/'
	elif [[ "$1" == '--opt6' ]]; then
		xdg-open 'https://www.twitter.com/'
	fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $option_1)
		run_cmd --opt1
        ;;
    $option_2)
		run_cmd --opt2
        ;;
    $option_3)
		run_cmd --opt3
        ;;
    $option_4)
		run_cmd --opt4
        ;;
    $option_5)
		run_cmd --opt5
        ;;
    $option_6)
		run_cmd --opt6
        ;;
esac
