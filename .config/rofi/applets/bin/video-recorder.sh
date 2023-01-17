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


get_area(){
    slop="$(slop -n -f '%w,%h,%x,%y')"
    w=$(echo "$slop" | cut -d ',' -f1)
    h=$(echo "$slop" | cut -d ',' -f2)
    x=$(echo "$slop" | cut -d ',' -f3)
    y=$(echo "$slop" | cut -d ',' -f4)
    [ $((w%2)) -eq 1 ] && w=$(( w + 1 ))
    [ $((h%2)) -eq 1 ] && h=$(( h + 1 ))
    [ $((x%2)) -eq 1 ] && x=$(( x + 1 ))
    [ $((y%2)) -eq 1 ] && y=$(( y + 1 ))
    wh="${w}x${h}"
}
screenshot_selected_area(){
    sleep .5
    grim -g "$(slurp)" "$screenshot_directory/$date.png"
    wl-copy -t image/png < "$screenshot_directory/$date.png"
    notify-send -i "$screenshot_directory/$date.png" "Screenshot" "Area screenshot taken"
}
screenshot_full_screen(){
    grim -o "$activemon" "$screenshot_directory/$date.png"
    wl-copy -t image/png < "$screenshot_directory/$date.png"
    notify-send -i "$screenshot_directory/$date.png" "Screenshot" "Full screen screenshot taken"
}
screenshot_left_screen(){
    ffcast -vv -g ${Res[3]} png "$screenshot_directory/$date.png"
    xclip -selection clipboard -t image/png "$screenshot_directory/$date.png"
    notify-send -i "$screenshot_directory/$date.png" "Screenshot" "Full screen screenshot taken"
}
screenshot_right_screen(){
    ffcast -vv -g ${Res1[2]} png "$screenshot_directory/$date.png"
    xclip -selection clipboard -t image/png "$screenshot_directory/$date.png"
    notify-send -i "$screenshot_directory/$date.png" "Screenshot" "Full screen screenshot taken"
}
video_selected_area(){
    get_area
    ffmpeg -hide_banner -loglevel error \
    -f x11grab -video_size "$wh" -framerate 60 -i :0.0+"$x","$y" -pix_fmt yuv420p "$videos_directory/$date.mp4"
    ffmpeg -i "$videos_directory/$date.mp4" -ss 00:00:01.000 -vframes 1 "/tmp/$date.png"
    notify-send -i "/tmp/$date.png" "Video" "Area video taken"
}
video_full_screen(){
    ffmpeg -hide_banner -loglevel error \
    -f x11grab -video_size "$screen_resolution" -framerate 60 -i :0.0 -pix_fmt yuv420p "$videos_directory/$date.mp4"
    ffmpeg -i "$videos_directory/$date.mp4" -ss 00:00:01.000 -vframes 1 "/tmp/$date.png"
    notify-send -i "/tmp/$date.png" "Video" "Full screen video taken"
}
video_full_screen_rgba(){
    ffmpeg -hide_banner -loglevel error \
    -f x11grab -video_size "$screen_resolution" -framerate 60 -i :0.0 -pix_fmt rgba "$videos_directory/$date.mp4"
    ffmpeg -i "$videos_directory/$date.mp4" -ss 00:00:01.000 -vframes 1 "/tmp/$date.png"
    notify-send -i "/tmp/$date.png" "Video" "Full screen video taken (rgba)"
}
audio_microphone(){
    ffmpeg -f pulse -i "$microphone" -metadata title="$date" "$audio_directory/$date.mp3"
    notify-send "Audio" "Microphone audio recorded"
}
audio_desktop(){
    ffmpeg -f pulse -i alsa_output.usb-SteelSeries_SteelSeries_Arctis_7-00.mono-chat.monitor -metadata title="$date" "$audio_directory/$date.mp3"
    notify-send "Audio" "Desktop audio recorded"
}
video_selected_area_audio_microphone(){
    get_area
    ffmpeg -hide_banner -loglevel error \
    -f x11grab -video_size "$wh" -framerate 60 -i :0.0+"$x","$y" \
    -f alsa -i default -pix_fmt yuv420p "$videos_directory/$date.mp4"
    ffmpeg -i "$videos_directory/$date.mp4" -ss 00:00:01.000 -vframes 1 "/tmp/$date.png"
    notify-send -i "/tmp/$date.png" "Video" "Area video with audio taken"
}
video_full_screen_audio_microphone(){
    ffmpeg -hide_banner -loglevel error \
    -f x11grab -video_size "$screen_resolution" -framerate 60 -i :0.0 \
    -f alsa -i default -pix_fmt yuv420p "$videos_directory/$date.mp4"
    ffmpeg -i "$videos_directory/$date.mp4" -ss 00:00:01.000 -vframes 1 "/tmp/$date.png"
    notify-send -i "/tmp/$date.png" "Video" "Full screen video with audio taken"
}
video_selected_area_audio_desktop(){
    get_area
    ffmpeg -hide_banner -loglevel error \
    -f x11grab -video_size "$wh" -framerate 60 -i :0.0+"$x","$y" \
    -f pulse -ac 2 -i alsa_output.usb-SteelSeries_SteelSeries_Arctis_7-00.mono-chat.monitor -pix_fmt yuv420p "$videos_directory/$date.mp4"
    ffmpeg -i "$videos_directory/$date.mp4" -ss 00:00:01.000 -vframes 1 "/tmp/$date.png"
    notify-send -i "/tmp/$date.png" "Video" "Area video with audio taken"
}
video_full_screen_audio_desktop(){
    ffmpeg -hide_banner -loglevel error \
    -f x11grab -video_size "$screen_resolution" -framerate 60 -i :0.0 \
    -f pulse -ac 2 -i alsa_output.usb-SteelSeries_SteelSeries_Arctis_7-00.mono-chat.monitor -pix_fmt yuv420p "$videos_directory/$date.mp4"
    ffmpeg -i "$videos_directory/$date.mp4" -ss 00:00:01.000 -vframes 1 "/tmp/$date.png"
    notify-send -i "/tmp/$date.png" "Video" "Full screen video taken"
}
video_left_screen(){
    ffmpeg -hide_banner -loglevel debug -show_region 0 \
    -f x11grab -video_size ${Res[3]%%+*} -framerate 60 -i :0.0+${Offset//[+]/,} -pix_fmt yuv420p "$videos_directory/$date.mp4"
    ffmpeg -i "$videos_directory/$date.mp4" -ss 00:00:01.000 -vframes 1 "/tmp/$date.png"
    notify-send -i "/tmp/$date.png" "Video" "Full screen video taken"
}
video_left_screen_desktop(){
    ffmpeg\
    -f x11grab -video_size ${Res[3]%%+*} -framerate 60 -i :0.0+${Offset//[+]/,} \
    -f pulse -ac 2 -i alsa_output.usb-SteelSeries_SteelSeries_Arctis_7-00.mono-chat.monitor -pix_fmt yuv420p "$videos_directory/$date.mp4"
    ffmpeg -i "$videos_directory/$date.mp4" -ss 00:00:01.000 -vframes 1 "/tmp/$date.png"
    notify-send -i "/tmp/$date.png" "Video" "Left monitor video with desktop audio taken"
}
video_left_screen_microphone(){
    ffmpeg\
    -f x11grab -video_size ${Res[3]%%+*} -framerate 60 -i :0.0+${Offset//[+]/,} \
    -f alsa -i default -pix_fmt yuv420p "$videos_directory/$date.mp4"
    ffmpeg -i "$videos_directory/$date.mp4" -ss 00:00:01.000 -vframes 1 "/tmp/$date.png"
    notify-send -i "/tmp/$date.png" "Video" "Left monitor video with mic audio taken"
}
video_right_screen(){
    ffmpeg\
    -f x11grab -video_size ${Res1[2]%%+*} -framerate 60 -i :0.0+${Offset1//[+]/,}\
    -f pulse -ac 2 -i alsa_output.usb-SteelSeries_SteelSeries_Arctis_7-00.mono-chat.monitor -pix_fmt yuv420p "$videos_directory/$date.mp4"
    ffmpeg -i "$videos_directory/$date.mp4" -ss 00:00:01.000 -vframes 1 "/tmp/$date.png"
    notify-send -i "/tmp/$date.png" "Video" "Right monitor video taken"
}
video_right_screen_desktop(){
    ffmpeg\
    -f x11grab -video_size ${Res1[2]%%+*} -framerate 60 -i :0.0+${Offset1//[+]/,}\
    -f pulse -ac 2 -i alsa_output.usb-SteelSeries_SteelSeries_Arctis_7-00.mono-chat.monitor -pix_fmt yuv420p "$videos_directory/$date.mp4"
    ffmpeg -i "$videos_directory/$date.mp4" -ss 00:00:01.000 -vframes 1 "/tmp/$date.png"
    notify-send -i "/tmp/$date.png" "Video" "Right monitor video with desktop audio taken"
}
video_right_screen_microphone(){
    ffmpeg\
    -f x11grab -video_size ${Res1[2]%%+*} -framerate 60 -i :0.0+${Offset1//[+]/,}\
    -f alsa -i default -pix_fmt yuv420p "$videos_directory/$date.mp4"
    ffmpeg -i "$videos_directory/$date.mp4" -ss 00:00:01.000 -vframes 1 "/tmp/$date.png"
    notify-send -i "/tmp/$date.png" "Video" "Right monitor video with mic audio taken"
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
-sa | -screenshot_selected_area
-sf | -screenshot_full_screen
-va | -video_selected_area
-vf | -video_full_screen
-am | -audio_microphone
-ad | -audio_desktop
-vaam | -video_selected_area_audio_microphone
-vfam | -video_full_screen_audio_microphone
-vfad | -video_selected_area_audio_desktop
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
    -sa | -screenshot_selected_area)
        screenshot_selected_area
        ;;
    -sf | -screenshot_full_screen)
        screenshot_full_screen
        ;;
    -sl | -screenshot_left_screen)
        screenshot_left_screen
        ;;
    -sr | -screenshot_right_screen)
        screenshot_right_screen
        ;;
    -va | -video_selected_area)
        video_selected_area
        ;;
    -vf | -video_full_screen)
        video_full_screen
        ;;
    -vf_rgba | -video_full_screen_rgba)
        video_full_screen_rgba
        ;;
    -am | -audio_microphone)
        audio_microphone
        ;;
    -ad | -audio_desktop)
    audio_desktop
        ;;
    -vaam | -video_selected_area_audio_microphone)
        video_selected_area_audio_microphone
        ;;
    -vfam | -video_full_screen_audio_microphone)
        video_full_screen_audio_microphone
        ;;
    -vsad | -video_selected_area_audio_desktop)
        video_selected_area_audio_desktop
        ;;
    -vfad | -video_full_screen_audio_desktop)
        video_full_screen_audio_desktop
        ;;
    -vl | -video_left_screen)
        video_left_screen
        ;;
    -vlad | -video_left_screen_desktop)
        video_left_screen_desktop
        ;;
    -vlam | -video_left_screen_microphone)
        video_left_screen_microphone
        ;;
    -vr | -video_right_screen)
        video_right_screen
        ;;
    -vrad | -video_right_screen_desktop)
        video_right_screen_desktop
        ;;
    -vram | -video_right_screen_microphone)
        video_right_screen_microphone
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
	elif [[ "$1" == 'vaam' ]]; then
		video_selected_area_audio_microphone
	elif [[ "$1" == 'vfam' ]]; then
		video_full_screen_audio_microphone
	elif [[ "$1" == 'vfad' ]]; then
		video_selected_area_audio_desktop
else
	echo -e "Available Options : va vf vaam vfam vfad"
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
		run_cmd vaam
        ;;
    $option_4)
		run_cmd vfam
        ;;
    $option_5)
		run_cmd vfad
        ;;
esac

main "$1" &
exit 0
