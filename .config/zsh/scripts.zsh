#!/usr/bin/env zsh

# Disk
hdd() {
  hdd="$(df -h | awk 'NR==4{print $3, $5}')"
  echo -e "HDD: $hdd"
}

# Volume
vol() {
    vol=`pamixer get Master | awk -F'[][]' 'END{ print $4":"$2 }' | sed 's/on://g'`
    echo -e "VOL: $vol"
}

# Fix the file name
if [[ -f "$XDG_CONFIG_HOME/zsh/plugins/zsh-completions/zsh-completions.plugin.zsh" ]]
then
    mv $HOME/.config/zsh/plugins/zsh-completions/zsh-completions.plugin.zsh $HOME/.config/zsh/plugins/zsh-completions/_zsh-completions.plugin.zsh
fi

# Add Vi text-objects for brackets and quotes
autoload -Uz select-bracketed select-quoted
zle -N select-quoted
zle -N select-bracketed
for km in viopp visual; do
  bindkey -M $km -- '-' vi-up-line-or-history
  for c in {a,i}${(s..)^:-\'\"\`\|,./:;=+@}; do
    bindkey -M $km $c select-quoted
  done
  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
    bindkey -M $km $c select-bracketed
  done
done

# Display width / height of an image
imgsize() {
    local width=$(identify -format "%w" "$1")> /dev/null
    local height=$(identify -format "%h" "$1")> /dev/null

    echo -e "Size of $1: $width*$height"
}

# Resize and create a new image
imgresize() {
    local filename=${1%\.*}
    local extension="${1##*.}"
    local separator="_"
    if [ ! -z $3 ]; then
        local finalName="$filename.$extension"
    else
        local finalName="$filename$separator$2.$extension"
    fi
    convert $1 -quality 100 -resize $2 $finalName
    echo "$finalName resized to $2"
}

# Resize every images with the same extension in the current folder
imgresizeall() {
    for f in *.${1}; do
        if [ ! -z $3 ]; then
            imgresize "$f" ${2} t
        else
            imgresize "$f" ${2}
        fi
    done
}

# Optimize the image and create a new image
imgoptimize() {
    local filename=${1%\.*}
    local extension="${1##*.}"
    local separator="_"
    local suffix="optimized"
    local finalName="$filename$separator$suffix.$extension"
    convert $1 -strip -interlace Plane -quality 85% $finalName
    echo "$finalName created"
}

# Optimize the image 
Imgoptimize() {
    local filename=${1%\.*}
    local extension="${1##*.}"
    local separator="_"
    local suffix="optimized"
    local convert $1 -strip -interlace Plane -quality 85% $1
    echo "$1 created"
}

# Optimize the images with same extension in current folder and create new images
imgoptimizeall() {
    for f in *.${1}; do
        imgoptimize "$f"
    done
}

# Optimize the images with same extension in current folder and replace them
Imgoptimizeall() {
    for f in *.${1}; do
        Imgoptimize "$f"
    done
}

# Display screen resolution
screenres() {
    [ ! -z $1 ] && xrandr --current | grep '*' | awk '{print $1}' | sed -n "$1p"
}

# Mount device with read/write permissions
mnt() {
    local FILE="/mnt/external"
    if [ ! -z $2 ]; then
        FILE=$2
    fi

    if [ ! -z $1 ]; then
        sudo mount "$1" "$FILE" -o rw
        echo "Device in read/write mounted in $FILE"
    fi

    if [ $# = 0 ]; then
        echo "You need to provide the device (/dev/sd*) - use lsblk"
    fi
}

# Unmount every devices in a specific folder recursively
umnt() {
    local DIRECTORY="/mnt"
    if [ ! -z $1 ]; then
        DIRECTORY=$1
    fi
    MOUNTED=$(grep $DIRECTORY /proc/mounts | cut -f2 -d" " | sort -r)
    cd "/mnt"
    sudo umount $MOUNTED
    echo "$MOUNTED unmounted"
}

# Mount mtp filesystem
mntmtp() {
    local DIRECTORY="$HOME/mnt"
    if [ ! -z $2 ]; then
        local DIRECTORY=$2
    fi
    if [ ! -d $DIRECTORY ]; then
        mkdir $DIRECTORY
    fi

    if [ ! -z $1 ]; then
        simple-mtpfs --device "$1" "$DIRECTORY"
        echo "MTPFS device in read/write mounted in $DIRECTORY"
    fi

    if [ $# = 0 ]; then
        echo "You need to provide the device number - use simple-mtpfs -l"
    fi
}

# Umount mtp filesystem
umntmtp() {
    local DIRECTORY="$HOME/mnt"
    if ; then
        DIRECTORY=$1
    fi
    cd $HOME
    umount $DIRECTORY
    echo "$DIRECTORY with mtp filesystem unmounted"
}

# Create a new ssh key at ~/.ssh/<name> with permission 700
ssh-create() {
    if [ ! -z "$1" ]; then
        ssh-keygen -f $HOME/.ssh/$1 -t rsa -N '' -C "$1"
        chmod 700 $HOME/.ssh/$1*
    fi
}

# Use dd to copy an entire hard disk to another disk output
dback () {
    if [ ! -z $1 ] && [ ! -z $2 ]; then
        if [ ! -z $3 ]; then
            BS=$3
        else
            BS="512k"
        fi

        dialog --defaultno --title "Are you sure?" --yesno "This will copy $1 to $2 (bitsize: $BS). Everything on $2 will be deleted.\n\n
        Are you sure?"  15 60 || exit

        (sudo pv -n $1 | sudo dd of=$2 bs=$BS conv=notrunc,noerror) 2>&1 | dialog --gauge "Backup from disk $1 to disk $2... please wait" 10 70 0
    else
        echo "You need to provide an input disk as first argument (i.e /dev/sda) and an output disk as second argument (i.e /dev/sdb)"
    fi
}

# Extract any archive automatically. Require tar and unzip - extract <archive_file>
extract() {
    for file in "$@"
    do
        if [ -f $file ]; then
            ex $file
        else
            echo "'$file' is not a valid file"
        fi
    done
}

# Create a folder with the name of the archive, extract the archive in. - mkextract <archive_file>
mkextract() {
    for file in "$@"
    do
        if [ -f $file ]; then
            local filename=${file%\.*}
            mkdir -p $filename
            cp $file $filename
            cd $filename
            ex $file
            rm -f $file
            cd -
        else
            echo "'$1' is not a valid file"
        fi
    done
}

# Compress one or multiple folder or files. - compress <files>...
compress() {
    local DATE="$(date +%Y%m%d-%H%M%S)"
    tar cvzf "$DATE.tar.gz" "$@"
}

# List of port opens, fuzzy searchable via fzf
ports() {
    sudo netstat -tulpn | grep LISTEN | fzf;
}

# Download a video with best quality from Youtube - ydl <video_url>
ydlp() {
    if ; then
        youtube-dl --restrict-filenames -f 22 -o "%(autonumber)s-%(title)s.%(ext)s" "$1"
    else
        echo "You need to specify a playlist url as argument"
    fi
}

# Download a playlist from Youtube - ydlp <playlist_url> 
ydl() {
    if [ ! -z $1 ]; then
        youtube-dl --restrict-filenames -f 22 -o "%(title)s.%(ext)s" "$1"
    else
        echo "You need to specify a video url as argument"
    fi
}

# Create a folder like mkdir -p and jump to it. - mkcd
mkcd() {
    local dir="$*";
    local mkdir -p "$dir" && cd "$dir";
}

# Move a file or a folder, and create the filepath if it doesn't exist. - mkmv
mkmv() {
    local dir="$2"
    local tmp="$2"; tmp="${tmp: -1}"
    [ "$tmp" != "/" ] && dir="$(dirname "$2")"
    [ -d "$dir" ] ||
        mkdir -p "$dir" &&
        mv "$@"
    }

# Copy a file or a folder, and create the filepath if it doesn't exist. - mkcp
mkcp() {
    local dir="$2"
    local tmp="$2"; tmp="${tmp: -1}"
    [ "$tmp" != "/" ] && dir="$(dirname "$2")"
    [ -d "$dir" ] ||
        mkdir -p "$dir" &&
        cp -r "$@"
}

# Display the command more often used in the shell
historystat() {
    history 0 | awk '{print $2}' | sort | uniq -c | sort -n -r | head
}

# Use tinyurl to shorten the <url>.
tiny() {
    local URL=${1:?}
    curl -s "http://tinyurl.com/api-create.php?url=$1"
}

# Calculate number of pomodoro done for a specific time in hour(s) and minute(s). -pom <hours> <minutes> <duration=25>
pom() {
    local -r HOURS=${1:?}
    local -r MINUTES=${2:-0}
    local -r POMODORO_DURATION=${3:-25}

    bc <<< "(($HOURS * 60) + $MINUTES) / $POMODORO_DURATION"
}

# Calculate a mathematical operation. For example: calcul "2 * 3". - calcul <operation>
calcul() {
    bc -l <<< "$@"
}

# Create a server using Python with specific port. - serve <port=8888>
serve() {
    local -r PORT=${1:-8888}
    python2 -m SimpleHTTPServer "$PORT"
}

# Display the time for the prompt to appear when opening a new zsh instance. - promptspeed
promptspeed() {
    for i in $(seq 1 10); do /usr/bin/time zsh -i -c exit; done
}

# Search on duckduckgo using the text-based browser lynx. - duckduckgo <search>
duckduckgo() {
    lynx -vikeys -accept_all_cookies "https://lite.duckduckgo.com/lite/?q=$@"
}

# Display all autocompleted command in zsh, First column: command name Second column: completion function - zshcomp 
zshcomp() {
    for command completion in ${(kv)_comps:#-*(-|-,*)}
    do
        printf "%-32s %s\n" $command $completion
    done | sort
}

# Display command cheatsheet from cheat.sh. - cheat <command>
cheat() {
    curl cheat.sh/$1
}

# Create a taskell project <name>. - touchproject <name>
touchproject(){
    if [ -z $1 ];then
        echo "You need to pass a project name" && exit 1
    fi
    local project=$1
    cd "$CLOUD/project_management/"
    taskell $project
    cd -
}

# Source bash scripts (can't source from .zshrc)
pipes() {
    "$ZDOTDIR/bash-scripts/pipes.sh" "$@"
}

colorblocks() {
    "$ZDOTDIR/bash-scripts/colorblocks.sh" "$@"
}

githeat() {
    "$ZDOTDIR/bash-scripts/heatmap.sh" "$@"
}

bm() {
    "$ZDOTDIR/bash-scripts/bm.sh" "$@"
}

matrix() {
    "$ZDOTDIR/bash-scripts/matrix.sh" "$@"
}
