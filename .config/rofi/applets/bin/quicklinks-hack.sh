#!/usr/bin/env bash

## Author  : Twilight4
## Github  : @Twilight4
#
## Applets : Quick Links

# Import Current Theme
source "$HOME"/.config/rofi/applets/shared/theme.bash
theme="$type/$style"

# Theme Elements
prompt='Hacking Platforms'
mesg="Using '$BROWSER' as web browser"

if [[ ( "$theme" == *'type-1'* ) || ( "$theme" == *'type-3'* ) || ( "$theme" == *'type-5'* ) ]]; then
	list_col='1'
	list_row='6'
elif [[ ( "$theme" == *'type-2'* ) || ( "$theme" == *'type-4'* ) ]]; then
	list_col='6'
	list_row='1'
fi

if [[ ( "$theme" == *'type-1'* ) || ( "$theme" == *'type-5'* ) ]]; then
	efonts="JetBrains Mono Nerd Font 10"
else
	efonts="JetBrains Mono Nerd Font 28"
fi

# Options
layout=`cat ${theme} | grep 'USE_ICON' | cut -d'=' -f2`
if [[ "$layout" == 'NO' ]]; then
	option_1=" Hack The Box"
	option_2=" TryHackMe"
	option_3=" PortSwigger"
	option_4=" Proving Grounds"
	option_5=" PentesterLab"
	option_6=" Root Me"
	option_7=" PWNX"
else
	option_1=""
	option_2=""
	option_3=""
	option_4=""
	option_5=""
	option_6=""
	option_7=""
fi

# Rofi CMD
rofi_cmd() {
	rofi -theme-str "listview {columns: $list_col; lines: $list_row;}" \
		-theme-str 'textbox-prompt-colon {str: "";}' \
		-theme-str "element-text {font: \"$efonts\";}" \
		-dmenu \
		-p "$prompt" \
		-mesg "$mesg" \
		-markup-rows \
		-theme ${theme}
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5\n$option_6" | rofi_cmd
}

# Execute Command
run_cmd() {
	if [[ "$1" == '--opt1' ]]; then
		xdg-open 'https://www.hackthebox.com/'
	elif [[ "$1" == '--opt2' ]]; then
		xdg-open 'https://tryhackme.com/'
	elif [[ "$1" == '--opt3' ]]; then
		xdg-open 'https://portswigger.net/web-security/all-labs'
	elif [[ "$1" == '--opt4' ]]; then
		xdg-open 'https://www.offensive-security.com/labs/'
	elif [[ "$1" == '--opt5' ]]; then
		xdg-open 'https://pentesterlab.com/'
	elif [[ "$1" == '--opt6' ]]; then
		xdg-open 'https://www.root-me.org/?lang=en/'
	elif [[ "$1" == '--opt7' ]]; then
		xdg-open 'https://pwnx.io/'
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
    $option_7)
		run_cmd --opt6
        ;;
esac
