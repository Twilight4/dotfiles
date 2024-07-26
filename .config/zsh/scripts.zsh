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

net-pubip-country() {
    whois "$1" | grep -i country | head -n1
}

# zoxide
j() {
    z "$@" && lsd -l --hyperlink=auto
}

# Output only ports from masscan-all scan (nb-enum-network-masscan-all)
# and save in variable $p
m-ports() {
  local file="$1"
  p=$(awk '/^open/ {print $3}' "$file" | sort -n | uniq | tr '\n' ',' | sed 's/,$//')
  echo "ports saved in variable: \$p=$p"
}

# Search nmap lse scripts: nmap-grep ftp
nmap-grep() {
  q="$1"
  ls /usr/share/nmap/scripts/* | rg -ie $q*
}

# Nmap grepping: nmap-services <output-scan.gnmap>
nmap-services() {
  local file="$1"
  grep -E -v "^#|Status: Up" "$file" | cut -d ' ' -f4- | tr ',' '\n' | \
  sed -e 's/^[ \t]*//' | awk -F '/' '{print $7}' | grep -v "^$" | \
  sort | uniq -c | sort -k 1 -nr
}

# Nmap grepping: nmap-top-10 <output-scan.gnmap>
nmap-top-10() {
  local NMAP_FILE="$1"
  grep -E -v "^#|Status: Up" "$NMAP_FILE" | cut -d' ' -f4- | \
  sed -n -e 's/Ignored.*//p' | tr ',' '\n' | sed -e 's/^[ \t]*//' | \
  sort -n | uniq -c | sort -k 1 -r | head -n 10
}

# Source: https://github.com/leonjza/awesome-nmap-grep
nmap-ports() {
  local NMAP_FILE="$1"
  grep -E -v "^#|Status: Up" "$NMAP_FILE" | cut -d' ' -f2,4- | \
  sed -n -e 's/Ignored.*//p' | \
  awk '{print "Host: " $1 " Ports: " NF-1; $1=""; for(i=2; i<=NF; i++) { a=a" "$i; }; split(a,s,","); for(e in s) { split(s[e],v,"/"); printf "%-8s %s/%-7s %s\n" , v[2], v[3], v[1], v[5]}; a="" }'
}

# Source: https://github.com/leonjza/awesome-nmap-grep
nmap-banner() {
  local NMAP_FILE="$1"
  grep -E -v "^#|Status: Up" "$NMAP_FILE" | cut -d' ' -f2,4- | \
  awk -F, '{split($1,a," "); split(a[2],b,"/"); print a[1] " " b[1]; for(i=2; i<=NF; i++) { split($i,c,"/"); print a[1] c[1] }}' | \
  xargs -L1 nc -v -w1
}

# Convert ASCII into UTF16-LE for windows compatibility and then encode powershell command to base64
# Pass the encoded command in powershell using -enc option
# Requires 'rbkb' tool
pow-enc() {
  echo -n "$@" | iconv -f ASCII -t UTF-16LE | base64
}

# Prettify help/cheat pages (using fchtc)
#c() {
#  command cheat "$@" | bat --plain --language=help
#}

help() {
  "$@" --help 2>&1 | bat --plain --language=help
}

h() {
  "$@" --help 2>&1 | bat --plain --language=help
}

# Prettify org mode files output
cato() {
	sed -e 's/^\* .*$/\x1b[94m&\x1b[0m/' -e 's/^\*\*.*$/\x1b[96m&\x1b[0m/' -e 's/=\([^=]*\)=/\o033[1;32m\1\o033[0m/g; s/^\( \{0,6\}\)-/•/g' -e '/^\(:PROPERTIES:\|:ID:\|:END:\|#\+date:\)/d' "$@" | command bat --language=org --style=plain --color=always
}

# Better diff
diff() {
  # I want to use less for this commmand
  PAGER=less
  command diff -u "$@" | delta --features side-by-side
}

diffd() {
  # I want to use less for this commmand
  PAGER=less
  command diff -r -u "$@" | delta --features side-by-side
}

# rm with exclude (ignore)
rmi() {
  if [ -z "$1" ]; then
    echo -e "\e[34mUsage: rmi <pattern>\e[0m"
    echo -e "\e[32mExample: rmi '*.mp4'\e[0m"
  else
    find . -type f ! -name "$1" -exec trash -rfv {} +
  fi
}

# rm with exclude (ignore)
mvi() {
  if [ -z "$1" ]; then
    echo -e "\e[31mUsage: mvi <pattern> <destination>\e[0m"
    echo -e "\e[32mExample: mvi '*.mp4' /path/to/destination\e[0m"
  else
    find . -type f ! -name "$1" -exec mv -t "$2" {} +
  fi
}

# Display width / height of an image
imgsize() {
    local width=$(identify -format "%w" "$1")> /dev/null
    local height=$(identify -format "%h" "$1")> /dev/null
    echo -e "\e[32mSize of $1: $width*$height\e[0m"
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
    echo -e "\e[32m$finalName resized to $2\e[0m"
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
    echo -e "\e[32m$finalName created\e[0m"
}

# Optimize the image 
Imgoptimize() {
    local filename=${1%\.*}
    local extension="${1##*.}"
    local separator="_"
    local suffix="optimized"
    local convert $1 -strip -interlace Plane -quality 85% $1
    echo -e "\e[32m$1 created\e[0m"
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
        echo -e "\e[32mDevice in read/write mounted in \$FILE\e[0m"
    fi

    if [ $# = 0 ]; then
       echo -e "\e[31mYou need to provide the device (/dev/sd*) - use lsblk\e[0m"
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
    echo -e "\e[34m$MOUNTED unmounted\e[0m"
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
        echo -e "\e[32mMTPFS device in read/write mounted in $DIRECTORY\e[0m"
    fi

    if [ $# = 0 ]; then
        echo -e "\e[31mYou need to provide the device number - use simple-mtpfs -l\e[0m"
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
    echo -e "\e[32m$DIRECTORY with mtp filesystem unmounted\e[0m"
}

# Create a new ssh key at ~/.ssh/<name> with permission 700
ssh-create() {
    if [ ! -z "$1" ]; then
        ssh-keygen -f $HOME/.ssh/$1 -t rsa -N '' -C "$1"
        chmod 600 $HOME/.ssh/$1*
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
        echo -e "\e[31mYou need to provide an input disk as first argument (i.e /dev/sda) and an output disk as second argument (i.e /dev/sdb)\e[0m"
    fi
}

# Compress any file automatically - require tar and unzip
# Usage: compress <file/dir>
compress() {
    dirPriorToExe=$(pwd)
    dirName=$(dirname $1)
    baseName=$(basename $1)

    if [ -f $1 ]; then
        echo -e "\e[34mIt was a file change directory to $dirName\e[0m"
        cd $dirName
        case $2 in
        tar.bz2)
            tar cjf $baseName.tar.bz2 $baseName
            ;;
        tar.gz)
            tar czf $baseName.tar.gz $baseName
            ;;
        gz)
            gzip $baseName
            ;;
        tar)
            tar -cvvf $baseName.tar $baseName
            ;;
        zip)
            zip -r $baseName.zip $baseName
            ;;
        *)
            echo -e "\e[34mMethod not passed compressing using tar.bz2\e[0m"
            tar cjf $baseName.tar.bz2 $baseName
            ;;
        esac
        echo -e "\e[34mBack to Directory $dirPriorToExe\e[0m"
        cd $dirPriorToExe
    else
        if [ -d $1 ]; then
            echo -e "\e[34mIt was a Directory change directory to $dirName\e[0m"
            cd $dirName
            case $2 in
            tar.bz2)
                tar cjf $baseName.tar.bz2 $baseName
                ;;
            tar.gz)
                tar czf $baseName.tar.gz $baseName
                ;;
            gz)
                gzip -r $baseName
                ;;
            tar)
                tar -cvvf $baseName.tar $baseName
                ;;
            zip)
                zip -r $baseName.zip $baseName
                ;;
            *)
                echo -e "\e[34mMethod not passed compressing using tar.bz2\e[0m"
                tar cjf $baseName.tar.bz2 $baseName
                ;;
            esac
            echo -e "\e[34mBack to Directory $dirPriorToExe\e[0m"
            cd $dirPriorToExe
        else
            echo -e "\e[31m'$1' is not a valid file/folder\e[0m"
        fi
    fi
    echo -e "\e[34mDone\e[0m"
    echo -e "\e[34m###########################################\e[0m"
}

# Replace an existing value in a file
# Usage: file-replace <value_to_replace> <replace_with_value> <file>
file-replace() {
    if [ "$#" -ne 3 ]; then
        echo -e "\e[31mError: Usage - file-replace <replace> <with> <file>\e[0m"
        return 1
    fi
    
    local replace="$1"
    local with="$2"
    local file="$3"

    if [ ! -f "$file" ]; then
        echo -e "\e[31mError: File '$file' not found.\e[0m"
        return 1
    fi

    local temp_file=$(mktemp)

    if ! sed "s/${replace}/${with}/g" "$file" > "$temp_file"; then
        echo -e "\e[31mError: Failed to replace text in '$file'.\e[0m"
        rm "$temp_file"
        return 1
    fi

    mv "$temp_file" "$file"
    
    echo -e "\e[32mReplacement complete in '$file'.\e[0m"
}

# Run a script in the background
# Usage: ps-dtach <script_path>
ps-dtach() { 
    local script_path="$1"

    if [ -z "$script_path" ]; then
        echo -e "\e[31mError: Please provide the full path to the script\e[0m"
        return 1
    fi

    dtach -A "${script_path}" /bin/zsh
}

# Extract any archive automatically - require tar and unzip
# Usage: extract <archive.tar>
extract() {
    local remove_archive
    local success
    local file_name
    local extract_dir

    if (($# == 0)); then
        echo -e "\e[34mUsage: extract [-option] [file ...]\e[0m"
        echo
        echo -e "\e[34mOptions:\e[0m"
        echo -e "\e[32m    -r, --remove    Remove archive.\e[0m"
    fi

    remove_archive=1
    if [[ "$1" == "-r" ]] || [[ "$1" == "--remove" ]]; then
        remove_archive=0
        shift
    fi

    while (($# > 0)); do
        if [[ ! -f "$1" ]]; then
            echo -e "\e[31mextract: '$1' is not a valid file\e[0m" 1>&2
            shift
            continue
        fi

        success=0
        file_name="$(basename "$1")"
        extract_dir="$(echo "$file_name" | sed "s/\.${1##*.}//g")"
        case "$1" in
        *.tar.gz | *.tgz) [ -z $commands[pigz] ] && tar zxvf "$1" || pigz -dc "$1" | tar xv ;;
        *.tar.bz2 | *.tbz | *.tbz2) tar xvjf "$1" ;;
        *.tar.xz | *.txz) tar --xz --help &>/dev/null &&
            tar --xz -xvf "$1" ||
            xzcat "$1" | tar xvf - ;;
        *.tar.zma | *.tlz) tar --lzma --help &>/dev/null &&
            tar --lzma -xvf "$1" ||
            lzcat "$1" | tar xvf - ;;
        *.tar) tar xvf "$1" ;;
        *.gz) [ -z $commands[pigz] ] && gunzip "$1" || pigz -d "$1" ;;
        *.bz2) bunzip2 "$1" ;;
        *.xz) unxz "$1" ;;
        *.lzma) unlzma "$1" ;;
        *.Z) uncompress "$1" ;;
        *.zip | *.war | *.jar | *.sublime-package) unzip "$1" -d $extract_dir ;;
        *.rar) unrar x -ad "$1" ;;
        *.7z) 7za x "$1" ;;
        *.deb)
            mkdir -p "$extract_dir/control"
            mkdir -p "$extract_dir/data"
            cd "$extract_dir"
            ar vx "../${1}" >/dev/null
            cd control
            tar xzvf ../control.tar.gz
            cd ../data
            tar xzvf ../data.tar.gz
            cd ..
            rm *.tar.gz debian-binary
            cd ..
            ;;
        *)
            echo -e "\e[31mextract: '$1' cannot be extracted\e[0m" 1>&2
            success=1
            ;;
        esac

        ((success = $success > 0 ? $success : $?))
        (($success == 0)) && (($remove_archive == 0)) && rm "$1"
        shift
    done
}

# Create a folder with the name of the archive and extract the archive in
# Usage: mkextract <archive_file>
mkextract() {
    for file in "$@"
    do
        if [ -f $file ]; then
            local filename=${file%\.*}
            mkdir -p $filename
            cp $file $filename
            cd $filename
            extract $file
            rm -f $file
            cd -
        else
            echo -e "\e[31m'$1' is not a valid file\e[0m"
        fi
    done
}

# Colour/Color echo prompt outputs
# Usage: cecho @b@green[[Success]]
cecho() (
  echo "$@" | sed \
    -e "s/\(\(@\(red\|green\|yellow\|blue\|magenta\|cyan\|white\|reset\|b\|u\)\)\+\)[[]\{2\}\(.*\)[]]\{2\}/\1\4@reset/g" \
    -e "s/@red/$(tput setaf 1)/g" \
    -e "s/@green/$(tput setaf 2)/g" \
    -e "s/@yellow/$(tput setaf 3)/g" \
    -e "s/@blue/$(tput setaf 4)/g" \
    -e "s/@magenta/$(tput setaf 5)/g" \
    -e "s/@cyan/$(tput setaf 6)/g" \
    -e "s/@white/$(tput setaf 7)/g" \
    -e "s/@reset/$(tput sgr0)/g" \
    -e "s/@b/$(tput bold)/g" \
    -e "s/@u/$(tput sgr 0 1)/g"
)

# Query if a package is installed or not  
# Usage: pkg-query <package_name>, <package_name2>
pkg-query() {
    for pkg in "$@"; do
        dpkg -l | grep -qw $pkg && echo -e "\e[32m[+] ${pkg} is installed\e[0m" || echo -e "\e[31mError: ${pkg} is not installed\e[0m"
    done 
}

pac-query() {
    for pkg in "$@"; do
        echo -e "\e[32m[+] ${pkg} is installed\e[0m" && paru -Qs --color always $pkg && echo || echo -e "\e[31mError: ${pkg} is not installed\e[0m"
    done 
}

# Download all videos in mp3 from a youtube channel
# Usage: ytdlall <channel_URL>
ytdlall() {
    if [ ! -z $1 ]; then
        yt-dlp -x --audio-format mp3 --restrict-filenames -P ~/music -o "%(title)s.%(ext)s" "$1"
    else
        echo -e "\e[31mError: You need to specify a video url as argument\e[0m"
    fi
}

# Download a playlist from Youtube
# Usage: ydlp <playlist_url> 
ydlp() {
    if ; then
        yt-dlp --restrict-filenames -f mp4 -P ~/videos -o "%(autonumber)s-%(title)s.%(ext)s" "$1"
    else
        echo -e "\e[31mError: You need to specify a playlist url as argument\e[0m"
    fi
}

# Download a playlist from Youtube only audio with best quality
# Usage: ydlap <playlist_url> 
ydlap() {
    if ; then
        yt-dlp --extract-audio --audio-format best --restrict-filenames -P ~/music -o "%(autonumber)s-%(title)s.%(ext)s" "$1"
    else
        echo -e "\e[31mError: You need to specify a playlist url as argument\e[0m"
    fi
}

# Download a video from Youtube in mp4 format
# Usage: ydl <video_url>
ydl() {
    if [ ! -z $1 ]; then
        yt-dlp --restrict-filenames -f mp4 -P ~/videos -o "%(title)s.%(ext)s" "$1"
    else
        echo -e "\e[31mError: You need to specify a video url as argument\e[0m"
    fi
}

# Download a video with best quality in mp4 format from Youtube
# Usage: ydlb <video_url>
ydlb() {
    if [ ! -z $1 ]; then
        yt-dlp --restrict-filenames -f bestvideo+bestaudio/best --merge-output-format mp4 -P ~/videos -o "%(title)s.%(ext)s" "$1"
    else
        echo -e "\e[31mError: You need to specify a video url as argument\e[0m"
    fi
}

# Download audio from Youtube video with best quality
# Usage: ydlab <video_url>
ydlab() {
    if [ ! -z $1 ]; then
        yt-dlp --extract-audio --audio-format best --restrict-filenames -P ~/music -o "%(title)s.%(ext)s" "$1"
    else
        echo -e "\e[31mError: You need to specify a video url as argument\e[0m"
    fi
}

# Download audio from Youtube video
# Usage: ydla <video_url>
ydla() {
    if [ ! -z $1 ]; then
        yt-dlp --extract-audio --restrict-filenames -f 22 -P ~/music -o "%(title)s.%(ext)s" "$1"
    else
        echo -e "\e[31mError: You need to specify a video url as argument\e[0m"
    fi
}

# Create a directory and jump to it
# Usage: mkcd <direcory>
mkcd() {
    local dir="$*"
    mkdir -p "$dir" && cd "$dir"
}

# Configure cd on quit for nnn
n() {
    # Block nesting of nnn in subshells
    if [[ "${NNNLVL:-0}" -ge 1 ]]; then
        echo -e "\e[31mnnn is already running\e[0m"
        return
    fi

    # The behaviour is set to cd on quit (nnn checks if NNN_TMPFILE is set)
    # If NNN_TMPFILE is set to a custom path, it must be exported for nnn to
    # see. To cd on quit only on ^G, remove the "export" and make sure not to
    # use a custom path, i.e. set NNN_TMPFILE *exactly* as follows:
    #     NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    # The backslash allows one to alias n to nnn if desired without making an
    # infinitely recursive alias
    \nnn -RA "$@"

    if [ -f "$NNN_TMPFILE" ]; then
            . "$NNN_TMPFILE"
            rm -f "$NNN_TMPFILE" > /dev/null
    fi
}

# Backup all files in cwd
backall() {
    for file in "$@"; do
        cp "$file" "$file".bak
    done
}

# Function to manage GitHub repositories
gh-sync() {
    # List of GitHub repositories with full paths
    local REPOS=(
        "$HOME/desktop/workspace/nobility:Twilight4/nobility"
        "$HOME/desktop/workspace/dotfiles:Twilight4/dotfiles"
        "$HOME/desktop/workspace/debian-setup:Twilight4/debian-setup"
        "$HOME/documents/org:Twilight4/org"
        "$HOME/.config/cheat:Twilight4/cheats"
    )

    # Commit message for changes
    local COMMIT_MESSAGE="Auto-commit: local changes"

    # ANSI color codes for colored output
    local GREEN="\033[0;32m"
    local YELLOW="\033[0;33m"
    local RED="\033[0;31m"
    local NC="\033[0m"  # No Color

    # Iterate over each repository in the list
    for entry in "${REPOS[@]}"; do
        local repo_dir="${entry%%:*}"
        local repo="${entry##*:}"

        # Clone the repository if it does not exist
        if [ ! -d "$repo_dir" ]; then
            echo -e "${GREEN}Cloning ${repo} into ${repo_dir}...${NC}"
            echo
            git clone "git@github.com:$repo.git" "$repo_dir"
        else
            echo
            echo -e "${YELLOW}$repo already cloned in $repo_dir.${NC}"
        fi

        # Navigate to the repository directory
        cd "$repo_dir" || continue

        # Check for any changes in the repository
        if [ -n "$(git status --porcelain)" ]; then
            echo -e "${GREEN}Changes detected in $(basename "$repo_dir"). Committing and pushing...${NC}"
            echo
            git add .
            git commit -m "$COMMIT_MESSAGE"
            git push
        else
            echo
            echo -e "${YELLOW}No changes in $(basename "$repo_dir").${NC}"
        fi
    done

    echo
    echo -e "${GREEN}All repositories processed.${NC}"
}

# Function to sync data with Mega cloud
mega-sync-on() {
    # ANSI color codes
    GREEN='\033[0;32m'
    RED='\033[0;31m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    NC='\033[0m' # No Color

    # Check if the user is already logged in
    login_status=$(mega-login 2>&1)

    if echo "$login_status" | grep -q "Already logged in. Please log out first."; then
        echo -e "${GREEN}You are already logged in. Starting synchronization...${NC}"

        # Synchronize directories
        mega-sync /home/twilight/desktop/projects /SYNCED-DATA/desktop/projects/
        mega-sync /home/twilight/documents/creds/ /SYNCED-DATA/documents/creds/
        mega-sync /home/twilight/documents/openvpn/ /SYNCED-DATA/documents/openvpn/
        mega-sync /home/twilight/documents/pdfs/ /SYNCED-DATA/documents/pdfs/
        mega-sync /home/twilight/.ssh/ /SYNCED-DATA/.ssh/

        # Sync individual files
        mega-put ~/.config/FreeTube/history.db ~/.config/FreeTube/playlists.db ~/.config/FreeTube/profiles.db ~/.config/FreeTube/settings.db /SYNCED-DATA/.config/FreeTube

        echo -e "${GREEN}Synchronization completed.${NC}"
        echo -e "${GREEN}Please run 'mega-sync-off' to turn off syncing in order to keep a backup and log out.${NC}"
        echo
        echo -e "${BLUE}You can run 'watch mega-sync' command to check current syncing.${NC}"
    else
        echo -e "${RED}Please log in using 'mega-login <email> <pass>' and try again.${NC}"
    fi
}

# Function to stop syncing data with Mega cloud
mega-sync-off() {
    # ANSI color codes
    GREEN='\033[0;32m'
    RED='\033[0;31m'
    YELLOW='\033[1;33m'
    NC='\033[0m' # No Color

    mega-sync -d /home/twilight/desktop/projects
    mega-sync -d /home/twilight/documents/creds
    mega-sync -d /home/twilight/documents/openvpn
    mega-sync -d /home/twilight/documents/pdfs
    mega-sync -d /home/twilight/.ssh

    echo -e "${GREEN}All specified directories have been unsynced.${NC}"

    # Confirmation prompt before logging out
    echo
    echo -e "${YELLOW}Do you want to log out from Mega? (y/n)${NC} \c"
    read -r logout_confirm

    if [ "$logout_confirm" = "y" ]; then
        mega-logout
        echo
        echo -e "${GREEN}Logged out successfully.${NC}"
    else
        echo -e "${GREEN}Logout cancelled.${NC}"
    fi
}

# Move a file or a folder, and create the filepath if it doesn't exist
# Usage: mkmv <path>
mkmv() {
    local dir="$2"
    local tmp="$2"; tmp="${tmp: -1}"
    [ "$tmp" != "/" ] && dir="$(dirname "$2")"
    [ -d "$dir" ] ||
        mkdir -p "$dir" &&
        mv "$@"
}

# Copy a file or a folder, and create the filepath if it doesn't exist
# Usage: mkcp <path>
mkcp() {
    local dir="$2"
    local tmp="$2"; tmp="${tmp: -1}"
    [ "$tmp" != "/" ] && dir="$(dirname "$2")"
    [ -d "$dir" ] ||
        mkdir -p "$dir" &&
        cp -r "$@"
}

# Convert all markdown files in current working directory to org-mode files
mdtorg() {
    for file in *.md; do
        if [ -f "$file" ]; then
            output="${file%.md}.org"
            pandoc "$file" -o "$output"
            echo -e "\e[32mConverted $file to $output\e[0m"
        fi
    done
}

# Display the command more often used in the shell
historystat() {
    history 0 | awk '{print $2}' | sort | uniq -c | sort -n -r | head
}

# Sort a file uniq in place 
sort-uniq() {
    if [ $# -ne 1 ]; then
        echo -e "\e[31mError:\e[0m Usage: sort-uniq <filename>"
        return 1
    fi

    # Check if file exists
    if [ ! -f "$1" ]; then
        echo -e "\e[31mError:\e[0m File $1 not found"
        return 1
    fi

    # Create a temporary file
    tmpfile=$(mktemp) || { echo -e "\e[31mError:\e[0m Failed to create temporary file"; return 1; }

    # Sort and remove duplicates, then overwrite the original file
    sort -u "$1" > "$tmpfile" && mv "$tmpfile" "$1"
}

# Sort a file of IP addresses uniq in place 
sort-uniq-ip() {
    if [ $# -ne 1 ]; then
        echo -e "\e[31mError:\e[0m Usage: sort-uniq-ip <filename>"
        return 1
    fi

    # Check if file exists
    if [ ! -f "$1" ]; then
        echo -e "\e[31mError:\e[0m File $1 not found"
        return 1
    fi

    # Create a temporary file
    tmpfile=$(mktemp) || { echo -e "\e[31mError:\e[0m Failed to create temporary file"; return 1; }

    # Sort and remove duplicates of IP addresses, then overwrite the original file
    sort -u "$1" | sort -V > "$tmpfile" && mv "$tmpfile" "$1"
}

# Launch a program in a terminal without getting any output
gtfo() {
    "$@" &> /dev/null & disown
}

# Generate a password (default 20 characters)
pass() {
    local size=${1:-20}
    cat /dev/random | tr -dc '[:graph:]' | head -c$size
}

# Calculate repo size
# Usage: reposize <URL>
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

# Calculate number of pomodoro done for a specific time in hour(s) and minute(s)
# Usage: pom <hours> <minutes> <duration=25>
pom() {
    local -r HOURS=${1:?}
    local -r MINUTES=${2:-0}
    local -r POMODORO_DURATION=${3:-25}

    bc <<< "(($HOURS * 60) + $MINUTES) / $POMODORO_DURATION"
}

# Display the time for the prompt to appear when opening a new zsh instance
promptspeed() {
    for i in $(seq 1 10); do /usr/bin/time zsh -i -c exit; done
}

# Display all autocompleted command in zsh, First column: command name Second column: completion function
zshcomp() {
    for command completion in ${(kv)_comps:#-*(-|-,*)}
    do
        printf "%-32s %s\n" $command $completion
    done | sort
}

# Print PATH
paths() {
    echo $PATH | tr ':' '\n'
}

# Create new git repository
gitnewrepo() { 
	mkdir "$*" && cd "$*" && git init && hub create && touch README.md && echo "# " "$*" >>README.md && git add . && git commit -m "init" && git push -u origin HEAD; 
}

# Wrapper for git clone, 'gcl' to clone from clipboard
# Does not matter if the link you copied has "git clone" in front of it or not
gcl() {
    if [[ $# -gt 0 ]]; then
        git clone "$*" && cd "$(basename "$1" .git)"
        echo
        ls
    elif [[ "$(wl-paste)" == *"clone"* ]]; then
        $(wl-paste) && cd "$(basename "$(wl-paste)" .git)"
        echo
        ls
    else
        git clone --depth 1 "$(wl-paste)" && cd "$(basename "$(wl-paste)" .git)"
        echo
        ls
    fi
}

# Use tinyurl to shorten the
# Usage: tinyurl <url>
tiny() {
    local URL=${1:?}
    curl -s "http://tinyurl.com/api-create.php?url=$1"
}

# Scrape a single webpage with all assets
scrape-url() {
    wget --adjust-extension --convert-links --page-requisites --span-hosts --no-host-directories "$1"
}

# Usage: mdrender README.md
mdrender() {
    HTMLFILE="$(mktemp -u).html"
        jq --slurp --raw-input '{"text": "\(.)", "mode": "markdown"}' "$1" |
        curl -s --data @- https://api.github.com/markdown >"$HTMLFILE"
    echo -e "\e[32mOpening \"$HTMLFILE\"\e[0m"
    xdg-open "$HTMLFILE"
}

# Display command cheatsheet from cheat.sh
# Usage: cht <command>
cht() {
    curl cheat.sh/$1
}

# Backup directories from dir.csv to cloud directory
backup() {
    "$XDG_CONFIG_HOME/.local/bin/backup.sh" "$@" "$XDG_CONFIG_HOME/.local/bin/dir.csv"
}
