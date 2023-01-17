#!/bin/sh

# Import Current Theme
source "$HOME"/.config/rofi/applets/shared/theme.bash
theme="$type/$style"

# directories
videos_directory="$HOME/Videos/Recordings"
audio_directory="$HOME/Music/Recordings"

if [[ ! -d "$videos_directory" ]]; then
	mkdir -p "$videos_directory"
fi

if [[ ! -d "$audio_directory" ]]; then
	mkdir -p "$audio_directory"
fi

activemon=$(hyprctl monitors | grep -B 10 "focused: yes" | awk 'NR==3 {print $1}' RS='(' FS=')')

date=$(date '+%d-%m-%Y-%H-%M-%S')
# screen_resolution="$(xdpyinfo | grep dimensions | sed -r 's/^[^0-9]*([0-9]+x[0-9]+).*$/\1/')"
# microphone="$(pacmd list-sources | grep -E '^\s+name: .*alsa_input' | cut -c 8- | sed 's/[<,>]//g')"
# desktop="$(pacmd list-sources | grep -E '^\s+name: .*alsa_output.usb' | cut -c 8- | sed 's/[<,>]//g')"
declare -a Res=($(/usr/sbin/xrandr |grep " connected primary"));
declare Offset=${Res[3]#*+}
declare -a Res1=($(/usr/sbin/xrandr |grep " connected"));
declare Offset1=${Res1[2]#*+}

# Theme Elements
prompt='record/capture'

if [[ "$theme" == *'type-1'* ]]; then
	list_col='1'
	list_row='4'
	win_width='500px'
fi

# Options
layout=`cat ${theme} | grep 'USE_ICON' | cut -d'=' -f2`
if [[ "$layout" == 'NO' ]]; then
	option_1=" Capture Desktop"
	option_2=" Capture Area"
	option_3=" Capture Mic"
	option_4=" Capture Desktop Audio"
else
	option_1=""
	option_2=""
	option_3=""
	option_4=""
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

Coords=$(slurp)
video_selected_area(){
    timeout 600 wf-recorder -g "$Coords" -a -f "$videos_directory/$date.mp4"
    ffmpeg -i "$videos_directory/$date.mp4" -ss 00:00:01.000 -vframes 1 "/tmp/$date.png"
    notify-send -i "/tmp/$date.png" "Video" "Area video taken"
    wl-copy $videos_directory
}



video_full_screen(){
    ffmpeg -hide_banner -loglevel error \
    -f x11grab -video_size "$screen_resolution" -framerate 60 -i :0.0 -pix_fmt yuv420p "$videos_directory/$date.mp4"
    ffmpeg -i "$videos_directory/$date.mp4" -ss 00:00:01.000 -vframes 1 "/tmp/$date.png"
    notify-send -i "/tmp/$date.png" "Video" "Full screen video taken"
}

audio_microphone(){
    ffmpeg -f pulse -i "$microphone" -metadata title="$date" "$audio_directory/$date.mp3"
    notify-send "Audio" "Microphone audio recorded"
}

audio_desktop(){
    ffmpeg -f pulse -i alsa_output.usb-SteelSeries_SteelSeries_Arctis_7-00.mono-chat.monitor -metadata title="$date" "$audio_directory/$date.mp3"
    notify-send "Audio" "Desktop audio recorded"
}

stop(){
    killall --user $USER  --ignore-case  --signal INT  ffmpeg
    sleep 2
    pkill -fxn '(/\S+)*ffmpeg\s.*\sx11grab\s.*'
    pkill -fxn '(/\S+)*ffmpeg\s.*\spulse\s.*'
}
trap stop EXIT

# Execute Command
run_cmd() {
	if [[ "$1" == '-vf' ]]; then
		video_full_screen
	elif [[ "$1" == '-va' ]]; then
		video_selected_area
	elif [[ "$1" == '-am' ]]; then
		video_selected_area_audio_microphone
	elif [[ "$1" == '-ad' ]]; then
		video_full_screen_audio_microphone
	else
	echo -e "Available Options : va vf am ad"
	fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $option_1)
		run_cmd -vf
        ;;
    $option_2)
		run_cmd -va
        ;;
    $option_3)
		run_cmd -am
        ;;
    $option_4)
		run_cmd -ad
        ;;
esac

exit 0
