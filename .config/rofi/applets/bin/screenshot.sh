#!/usr/bin/env bash

## Author  : Twilight4
## Github  : @Twilight4
#
## Applets : Screenshot

# Import Current Theme and Icons
source "$HOME"/.config/rofi/applets/shared/theme.bash
theme="$type/$style"
iDIR="$HOME/.config/hypr/mako/icons"

# Screenshot
time=$(date +%Y-%m-%d-%H-%M-%S)
dir="$(xdg-user-dir PICTURES)/screenshots"
file="screenshot_${time}_${RANDOM}.png"

# Theme Elements
prompt='Screenshot'
mesg="DIR: `xdg-user-dir PICTURES`/screenshots"

if [[ "$theme" == *'type-1'* ]]; then
	list_col='1'
	list_row='5'
	win_width='400px'
elif [[ "$theme" == *'type-3'* ]]; then
	list_col='1'
	list_row='5'
	win_width='120px'
elif [[ "$theme" == *'type-5'* ]]; then
	list_col='1'
	list_row='5'
	win_width='520px'
elif [[ ( "$theme" == *'type-2'* ) || ( "$theme" == *'type-4'* ) ]]; then
	list_col='5'
	list_row='1'
	win_width='670px'
fi

# Options
layout=`cat ${theme} | grep 'USE_ICON' | cut -d'=' -f2`
if [[ "$layout" == 'NO' ]]; then
	option_1=" Capture Desktop"
	option_2=" Capture Area"
	option_3=" Capture Window"
	option_4=" Capture in 5s"
	option_5=" Capture in 10s"
else
	option_1=""
	option_2=""
	option_3=""
	option_4=""
	option_5=""
fi

# Rofi CMD
rofi_cmd() {
	rofi -theme-str "window {width: $win_width;}" \
		-theme-str "listview {columns: $list_col; lines: $list_row;}" \
		-theme-str 'textbox-prompt-colon {str: "";}' \
		-dmenu \
		-p "$prompt" \
		-mesg "$mesg" \
		-markup-rows \
		-theme ${theme}
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5" | rofi_cmd
}

if [[ ! -d "$dir" ]]; then
	mkdir -p "$dir"
fi

# notify and view screenshot
notify_view() {
notify_cmd_shot="notify-send -h string:x-canonical-private-synchronous:shot-notify -u low -i ${iDIR}/picture.png"
	${notify_cmd_shot} "Copied to clipboard."
	imv ${dir}/"$file"
	if [[ -e "$dir/$file" ]]; then
		${notify_cmd_shot} "Screenshot Saved."
	else
		${notify_cmd_shot} "Screenshot Deleted."
	fi
}

# countdown
countdown () {
	for sec in $(seq $1 -1 1); do
		notify-send -h string:x-canonical-private-synchronous:shot-notify -t 1000 -i "$iDIR"/timer.png "Taking shot in : $sec"
		sleep 1
	done
}

# take shots
shotnow () {
	sleep 0.6 && cd ${dir} && grim - | tee "$file" | wl-copy
	notify_view
}

shot5 () {
	countdown '5'
	sleep 1 && cd ${dir} && grim - | tee "$file" | wl-copy
	notify_view
}

shot10 () {
	countdown '10'
	sleep 1 && cd ${dir} && grim - | tee "$file" | wl-copy
	notify_view
}

shotwin () {
	w_pos=$(hyprctl activewindow | grep 'at:' | cut -d':' -f2 | tr -d ' ' | tail -n1)
	w_size=$(hyprctl activewindow | grep 'size:' | cut -d':' -f2 | tr -d ' ' | tail -n1 | sed s/,/x/g)
	cd ${dir} && grim -g "$w_pos $w_size" - | tee "$file" | wl-copy
	notify_view
}

shotarea () {
	cd ${dir} && grim -g "$(slurp -b 1B1F28CC -c E06B74ff -s C778DD0D -w 2)" - | tee "$file" | wl-copy
	notify_view
}

# Execute Command
run_cmd() {
	if [[ "$1" == '--now' ]]; then
		shotnow
	elif [[ "$1" == '--area' ]]; then
		shotarea
	elif [[ "$1" == '--win' ]]; then
		shotwin
	elif [[ "$1" == '--in5' ]]; then
		shot5
	elif [[ "$1" == '--in10' ]]; then
		shot10
else
	echo -e "Available Options : --now --in5 --in10 --win --area"
	fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $option_1)
		run_cmd --now
        ;;
    $option_2)
		run_cmd --area
        ;;
    $option_3)
		run_cmd --win
        ;;
    $option_4)
		run_cmd --in5
        ;;
    $option_5)
		run_cmd --in10
        ;;
esac
