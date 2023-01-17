OnExit {
    [[ -f $TmpRecordPath ]] && rm -f "$TmpRecordPath"
  	[[ -f $TmpPalettePath ]] && rm -f "$TmpPalettePath"
    killall --user $USER  --ignore-case  --signal INT  ffmpeg
    sleep 2
    pkill -fxn '(/\S+)*ffmpeg\s.*\sx11grab\s.*'
    pkill -fxn '(/\S+)*ffmpeg\s.*\spulse\s.*'
    exit 1 
}

trap OnExit EXIT
