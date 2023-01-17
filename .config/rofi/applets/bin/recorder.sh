#!/bin/sh

# Import Current Theme
source "$HOME"/.config/rofi/applets/shared/theme.bash
theme="$type/$style"

# directories
screenshot_directory="$HOME/Pictures/screenshots"
videos_directory="$HOME/Videos"
audio_directory="$HOME/Music"

# Theme Elements
prompt='Capture screen'

if [[ "$theme" == *'type-1'* ]]; then
	list_col='1'
	list_row='5'
	win_width='500px'
fi

# Options
layout=`cat ${theme} | grep 'USE_ICON' | cut -d'=' -f2`
if [[ "$layout" == 'NO' ]]; then
	option_1=" Capture Area"
	option_2=" Capture Desktop"
	option_3=" Capture Area w/ mic"
	option_4=" Capture Desktop w/ mic"
	option_5=" Capture Area only audio"
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





activemon=$(hyprctl monitors | grep -B 10 "focused: yes" | awk 'NR==3 {print $1}' RS='(' FS=')')

date=$(date '+%d-%m-%Y-%H-%M-%S')
# screen_resolution="$(xdpyinfo | grep dimensions | sed -r 's/^[^0-9]*([0-9]+x[0-9]+).*$/\1/')"
# microphone="$(pacmd list-sources | grep -E '^\s+name: .*alsa_input' | cut -c 8- | sed 's/[<,>]//g')"
# desktop="$(pacmd list-sources | grep -E '^\s+name: .*alsa_output.usb' | cut -c 8- | sed 's/[<,>]//g')"
declare -a Res=($(/usr/sbin/xrandr |grep " connected primary"));
declare Offset=${Res[3]#*+}
declare -a Res1=($(/usr/sbin/xrandr |grep " connected"));
declare Offset1=${Res1[2]#*+}



video_selected_area(){
    slop=$(slurp) || exit
    timeout 600 wf-recorder -g "$Coords" -a -f "$TmpRecordPath"  OR THIS ONE: "$videos_directory/$date.mp4"
    ffmpeg -i "$videos_directory/$date.mp4" -ss 00:00:01.000 -vframes 1 "/tmp/$date.png"
    notify-send -i "/tmp/$date.png" "Video" "Area video taken" || exit
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
    exit 1
}

help(){
cat << EOF 
-h | -help | --help
-s | -stop
-va | -video_selected_area
-vf | -video_full_screen
-am | -audio_microphone
-ad | -audio_desktop
EOF
}

main(){
while [ "$1" != "" ]; do
    PARAM="$1"
    case $PARAM in
    -h | -help | --help)
        help
        exit 1
        ;;
    -s | -stop)
        stop
        exit 1
        ;;
    -va | -video_selected_area)
        video_selected_area
        ;;
    -vf | -video_full_screen)
        video_full_screen
        ;;
    -am | -audio_microphone)
        audio_microphone
        ;;
    -ad | -audio_desktop)
    	audio_desktop
        ;;
    *)
        echo "ERROR: unknown parameter \"$PARAM\""
        help
        exit 1
        ;;
    esac
    shift
done
# done
set -e
}

# Execute Command
run_cmd() {
	if [[ "$1" == 'va' ]]; then
		video_selected_area
	elif [[ "$1" == 'vf' ]]; then
		video_full_screen
	elif [[ "$1" == 'am' ]]; then
		video_selected_area_audio_microphone
	elif [[ "$1" == 'ad' ]]; then
		video_full_screen_audio_microphone
else
	echo -e "Available Options : va vf am ad"
	fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $option_1)
		run_cmd va
        ;;
    $option_2)
		run_cmd vf
        ;;
    $option_3)
		run_cmd am
        ;;
    $option_4)
		run_cmd ad
        ;;
esac

main "$1" &
exit 0
