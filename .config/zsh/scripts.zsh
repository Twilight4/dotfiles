#!/usr/bin/env zsh

# Fix the file name
if [[ -f "$XDG_CONFIG_HOME/zsh/plugins/zsh-completions/zsh-completions.plugin.zsh" ]]
then
    mv $HOME/.config/zsh/plugins/zsh-completions/zsh-completions.plugin.zsh $HOME/.config/zsh/plugins/zsh-completions/_zsh-completions.plugin.zsh
fi

# Commands used by aliases
dns() {
  ip r | grep dhcp | awk '{print $3}'
}

extip() {
  curl -s http://ifconfig.me
}

hip() {
  hostname -i | awk '{print $1}'
}

mac() {
  ip a | grep ether | awk '{print $2}'
}

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

# Convert any image to jpg
imgtojpg() {
    for file in "$@"
    do
        local filename=${file%\.*}
        convert -quality 100 $file "${filename}.jpg"
    done
}


# Convert any image to webp - require cwebp
imgtowebp() {
    for file in "$@"
    do
        local filename=${file%\.*}
        cwebp -q 100 $file -o $(basename ${filename}).webp
    done
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


# # ex = EXtractor for all kinds of archives
# # usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.deb)       ar x $1      ;;
      *.tar.xz)    tar xf $1    ;;
      *.tar.zst)   tar xf $1    ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
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

# List of port opens, fuzzy searchable via fzf - require net-tools
ports() {
    sudo netstat -tulpn | grep LISTEN | fzf;
}

# Download a playlist from Youtube - ydlp <playlist_url> 
ydlp() {
    if ; then
        yt-dlp --restrict-filenames -f 22 -P ~/videos -o "%(autonumber)s-%(title)s.%(ext)s" "$1"
    else
        echo "You need to specify a playlist url as argument"
    fi
}

# Download a playlist from Youtube only audio with best quality - ydlp <playlist_url> 
ydlpa() {
    if ; then
        yt-dlp --extract-audio --audio-format best --restrict-filenames -f 22 -P ~/music -o "%(autonumber)s-%(title)s.%(ext)s" "$1"
    else
        echo "You need to specify a playlist url as argument"
    fi
}

# Download a video with best quality from Youtube - ydl <video_url>
ydl() {
    if [ ! -z $1 ]; then
        yt-dlp --restrict-filenames -f 22 -P ~/videos -o "%(title)s.%(ext)s" "$1"
    else
        echo "You need to specify a video url as argument"
    fi
}

# Download audio from Youtube video with best quality - ydl <video_url>
ydlab() {
    if [ ! -z $1 ]; then
        yt-dlp --extract-audio --audio-format best --restrict-filenames -f 22 -P ~/music -o "%(title)s.%(ext)s" "$1"
    else
        echo "You need to specify a video url as argument"
    fi
}

# Download audio from Youtube video - ydla <video_url>
ydla() {
    if [ ! -z $1 ]; then
        yt-dlp --extract-audio --restrict-filenames -f 22 -P ~/music -o "%(title)s.%(ext)s" "$1"
    else
        echo "You need to specify a video url as argument"
    fi
}

# Create a folder like mkdir -p and jump to it. - mkcd
mkcd() {
    local dir="$*"
    mkdir -p "$dir" && cd "$dir"
}

# Backup all files in cwd
back() {
    for file in "$@"; do
        cp "$file" "$file".bak
    done
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

# Connect my NAS to $HOME/Network
nas() {
    sshfs -o idmap=user,default_permissions nas:/share ~/Network
}

# Launch a program in a terminal without getting any output,
gtfo() {
    "$@" &> /dev/null & disown
}

# Generate a password - default 20 characters
pass() {
    local size=${1:-20}
    cat /dev/random | tr -dc '[:graph:]' | head -c$size
}

# Calculate repo size
reposize() {
  url=`echo $1 \
    | perl -pe 's#(?:https?://github.com/)([\w\d.-]+\/[\w\d.-]+).*#\1#g' \
    | perl -pe 's#git\@github.com:([\w\d.-]+\/[\w\d.-]+)\.git#\1#g'
  `
  printf "https://github.com/$url => "
  curl -s https://api.github.com/repos/$url \
  | jq '.size' \
  | numfmt --to=iec --from-unit=1024
}

# Calculate number of pomodoro done for a specific time in hour(s) and minute(s). -pom <hours> <minutes> <duration=25>
pom() {
    local -r HOURS=${1:?}
    local -r MINUTES=${2:-0}
    local -r POMODORO_DURATION=${3:-25}

    bc <<< "(($HOURS * 60) + $MINUTES) / $POMODORO_DURATION"
}

# Display the time for the prompt to appear when opening a new zsh instance. - promptspeed
promptspeed() {
    for i in $(seq 1 10); do /usr/bin/time zsh -i -c exit; done
}

# Display all autocompleted command in zsh, First column: command name Second column: completion function - zshcomp 
zshcomp() {
    for command completion in ${(kv)_comps:#-*(-|-,*)}
    do
        printf "%-32s %s\n" $command $completion
    done | sort
}

# Use tinyurl to shorten the <url>.
tiny() {
    local URL=${1:?}
    curl -s "http://tinyurl.com/api-create.php?url=$1"
}

# Display command cheatsheet from cheat.sh. - cheat <command>
cht() {
    curl cheat.sh/$1
}

# Aliases to bash scripts
pipes() {
    "$ZDOTDIR/bash-scripts/pipes.sh" "$@"
}

colorblocks() {
    "$ZDOTDIR/bash-scripts/colorblocks.sh" "$@"
}

git-jump() {
    "$ZDOTDIR/bash/scripts/git-jump.sh" "$@"
}

githeat() {
    "$ZDOTDIR/bash-scripts/heatmap.sh" "$@"
}

backup() {
    "$DOTFILES/bash/scripts/backup/backup.sh" "$@" "$CLOUD/dotfiles/dir.csv"
}

bm() {
    "$ZDOTDIR/bash-scripts/bm.sh" "$@"
}

optimize-video() {
    "$ZDOTDIR/bash-scripts/optimize-video.sh" "$@"
}
