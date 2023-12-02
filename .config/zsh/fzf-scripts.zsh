#!/usr/bin/env zsh

####################
# Change directory #
####################

# Search for a file and edit in $EDITOR
ff() {
  file=$(find . -type f -not -iname "*.jpg" -not -iname "*.jpeg" -not -iname "*.png" -not -iname "*.gif" \
      | fzf --query="$1" --no-multi --select-1 --exit-0 \
      --reverse --bind "j:down,k:up,alt-j:preview-down,alt-k:preview-up,ctrl-f:preview-page-down,ctrl-b:preview-page-up,q:abort" --preview 'bat --style=numbers --color=always --line-range :500 {}')
  if [[ -n "$file" ]]; then
    eval "$EDITOR" "$file"
  fi
}

# Preview file and copy the path to clipboard
ffp() {
  file=$(find . -type f | fzf --height 95% --bind "j:down,k:up,alt-j:preview-down,alt-k:preview-up,ctrl-f:preview-page-down,ctrl-b:preview-page-up,q:abort" --query="$1" --no-multi --select-1 --exit-0 \
      --reverse --preview 'bat --style=numbers --color=always --line-range :500 {}')
  if [[ -n "$file" ]]; then
    printf "%s" "$file" | wl-copy -n  # Copy path to clipboard
    echo "Copied to clipboard: $file"
  fi
}

# Find file and cd there
ffh() {
    local file
    local dir
    file=$(fzf +m --reverse --bind "j:down,k:up,alt-j:preview-down,alt-k:preview-up,ctrl-f:preview-page-down,ctrl-b:preview-page-up,q:abort" --preview "bat --style=numbers --color=always --line-range :500 {}" -q "$1") && dir=$(dirname "$file") && cd "$dir"
    lsd -l --hyperlink=auto
}

# Find Dirs (not hidden) (using cd . - improved version from enhancd with hidden)
# fdd() {
#     local dir
#     dir=$(find ${1:-.} -path '*/\.*' -prune \
#         -o -type d -print 2>/dev/null | fzf +m --reverse --preview 'exa --tree --group-directories-first --git-ignore --level 1 {}') &&
#         cd "$dir"
#     lsd -l --hyperlink=auto
# }

# Find Dirs + Hidden (using cd . - improved version from enhancd with hidden)
# fdh() {
#     local dir
#     dir=$(find ${1:-.} -type d 2>/dev/null | fzf +m) && cd "$dir"
#     lsd -l --hyperlink=auto
# }


################
# Command Line #
################

frm() (
    local SOURCES
    local REPLY
    local ERRORMSG
    if [[ "$#" -eq 0 ]]; then
        echo -n "would you like to use the force young padawan? y/n: "
        read -r REPLY
        #prompt user interactively to select multiple files with tab + fuzzy search
        SOURCES=$(find . -maxdepth 1 | fzf --multi)
        #we use xargs to capture filenames with spaces in them properly
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "using the force..."
            echo "$SOURCES" | xargs -I '{}' rm -rf {}
        else
            echo "$SOURCES" | xargs -I '{}' rm {}
        fi
        echo "removed selected file/folder(s)"
    else
        ERRORMSG=$(command rm "$@" 2>&1)
        #if error msg is not empty, prompt the user
        if [ -n "$ERRORMSG" ]; then
            echo "$ERRORMSG"
            echo -n "rm failed, would you like to use the force young padawan? y/n: "
            read -r REPLY
            if [[ "$REPLY" =~ ^[Yy]$ ]]; then
                echo "using the force..."
                command rm -rf "$@"
            fi
        else
            echo "removed file/folder"
        fi
    fi
)

# mv wrapper. if no command provided prompt user to
# interactively select multiple files with tab + fuzzy search
fmv() {
    local SOURCES
    local TARGET
    local REPLY
    local ERRORMSG
    if [[ "$#" -eq 0 ]]; then
        echo -n "would you like to use the force young padawan? y/n: "
        read -r REPLY

        # NOTE. THIS IS A ZSH IMPLEMENTATION ONLY FOR NOW. VARED IS ZSH BUILTIN.
        # FOR BASH use something like read -p "enter a directory: "
        echo "Use full path i.e /Users/admin/Git_Downloads/blog-sites"
        vared -p 'to whence shall be the files moved. state your target: ' -c TARGET
        if [ -z "$TARGET" ]; then
            echo 'no target specified'
            return 1
        fi

        # This corrects issue where directory is not found as ~ is
        # not expanded  properly When stored directly from user input
        if echo "$TARGET" | grep -q "~"; then
            TARGET=$(echo $TARGET | sed 's/~//')
            TARGET=~/$TARGET
        fi

        SOURCES=$(find . -maxdepth 1 | fzf --multi)
        #we use xargs to capture filenames with spaces in them properly
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "using the force..."
            echo "$SOURCES" | xargs -I '{}' mv -f {} '/'$TARGET'/'
        else
            echo "$SOURCES" | xargs -I '{}' mv {} '/'$TARGET'/'
        fi
        echo "moved selected file/folder(s)"
    else
        ERRORMSG=$(command mv "$@" 2>&1)
        #if error msg is not empty, prompt the user
        if [ -n "$ERRORMSG" ]; then
            echo "$ERRORMSG"
            echo -n "mv failed, would you like to use the force young padawan? y/n: "
            read -r REPLY
            if [[ "$REPLY" =~ ^[Yy]$ ]]; then
                echo "using the force..."
                command mv -f "$@"
            fi
        fi
    fi
}

# Man without options will use fzf to select a page
fman() (
    MAN="/usr/bin/man"
    if [ -n "$1" ]; then
        $MAN "$@"
        return $?
    else
        $MAN -k . | fzf --reverse --prompt='Man> ' --preview="echo {1} | sed 's/(.*//' | xargs $MAN -P cat" | awk '{print $1}' | sed 's/(.*//' | xargs $MAN
        return $?
    fi
)

# Docker
ssh-docker() {
    docker exec -it "$@" bash
}

# i.e. fzf-eval ls
fzf-eval() {
    echo | fzf -q "$*" --preview-window=up:99% --preview="eval {q}"
}

execute-fzf() {
    if [ -z "$1" ]; then
        file="$(fzf --multi)" # if no cmd provided default to ls
    else
        file=$(eval "$1 | fzf --multi") # otherwise pipe output of that command into fzf
    fi

    case "$file" in
    "") echo "fzf cancelled" ;;
    *) eval "$2" "$file" ;; #execute the second provided command on the selected file
    esac
}

# fh - Repeat history, assumes zsh
fhistory() {
    print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}

# Search env variables
vars() {
    local out
    out=$(env | fzf)
    echo $(echo $out | cut -d= -f2)
}

# Kill process
fkill() {
    if [ "$UID" != "0" ]; then
        pid=$(ps -f -u $UID | sed 1d | fzf -m --ansi --color fg:-1,bg:-1,hl:46,fg+:40,bg+:233,hl+:46 --color prompt:166,border:46 --height 30%  --border=sharp --prompt="➤  " --pointer="➤ " --marker="➤ " | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    fi

    if [ "x$pid" != "x" ]; then
        echo $pid | xargs kill -${1:-9}
    fi
}

# compress <file/dir> - Compress <file/dir>.
compress() {
    dirPriorToExe=$(pwd)
    dirName=$(dirname $1)
    baseName=$(basename $1)

    if [ -f $1 ]; then
        echo "It was a file change directory to $dirName"
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
            echo "Method not passed compressing using tar.bz2"
            tar cjf $baseName.tar.bz2 $baseName
            ;;
        esac
        echo "Back to Directory $dirPriorToExe"
        cd $dirPriorToExe
    else
        if [ -d $1 ]; then
            echo "It was a Directory change directory to $dirName"
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
                echo "Method not passed compressing using tar.bz2"
                tar cjf $baseName.tar.bz2 $baseName
                ;;
            esac
            echo "Back to Directory $dirPriorToExe"
            cd $dirPriorToExe
        else
            echo "'$1' is not a valid file/folder"
        fi
    fi
    echo "Done"
    echo "###########################################"
}

# extract <file.tar> - Extract <file.tar>.
extract() {
    local remove_archive
    local success
    local file_name
    local extract_dir

    if (($# == 0)); then
        echo "Usage: extract [-option] [file ...]"
        echo
        echo Options:
        echo "    -r, --remove    Remove archive."
    fi

    remove_archive=1
    if [[ "$1" == "-r" ]] || [[ "$1" == "--remove" ]]; then
        remove_archive=0
        shift
    fi

    while (($# > 0)); do
        if [[ ! -f "$1" ]]; then
            echo "extract: '$1' is not a valid file" 1>&2
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
            echo "extract: '$1' cannot be extracted" 1>&2
            success=1
            ;;
        esac

        ((success = $success > 0 ? $success : $?))
        (($success == 0)) && (($remove_archive == 0)) && rm "$1"
        shift
    done
}

# Colour/Color echo prompt outputs
#USAGE: cecho @b@green[[Success]]
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


####################
# Package Managers #
####################

# Package management
fpac() {
    pacman -Slq | fzf --multi --reverse --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S
}

fpar() {
    paru -Slq | fzf --multi --reverse --preview 'paru -Si {1}' | xargs -ro paru -S
}

fparr() {
    paru -Qq | fzf --multi --reverse --preview 'paru -Si {1}' | xargs -ro paru -Rns
}


#######
# Git #
#######

# Git log browser with FZF
fgl() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

# Git branch
fgb() {
  local branches branch
  branches=$(git --no-pager branch -vv) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

# Git commit history browser, when @param provided, its a shorthand for git commit
fgcom() {
    if [[ $# -gt 0 ]]; then
        git commit -m "$*"
    else
        git log --graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" |
            fzf --ansi --no-sort --reverse --tiebreak=index --preview \
                'f() { set -- $(echo -- "$@" | grep -o "[a-f0-9]\{7\}"); [ $# -eq 0 ] || git show --color=always $1 | delta ; }; f {}' \
                --bind "j:down,k:up,alt-j:preview-down,alt-k:preview-up,ctrl-f:preview-page-down,ctrl-b:preview-page-up,q:abort,ctrl-m:execute:
                    (grep -o '[a-f0-9]\{7\}' | head -1 |
                        xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                                            {}
                                            FZF-EOF" --preview-window=right:60%
    fi
}

# Show git staging area (git status)
fgs() {
    git rev-parse --git-dir >/dev/null 2>&1 || { echo "You are not in a git repository" && return; }
    local selected
    selected=$(git -c color.status=always status --short |
        fzf --height 50% "$@" --preview-window right:70% --border -m --ansi --nth 2..,.. \
            --preview '(git diff --color=always -- {-1} | delta | sed 1,4d; cat {-1}) | head -500' |
        cut -c4- | sed 's/.* -> //')
    if [[ $selected ]]; then
        for prog in $selected; do eval "$EDITOR" "$prog"; done
    fi
}


##############
# List files #
##############

# Search and run from list of aliases/functions
falias() {
    CMD=$(
        (
            (alias)
            (functions | grep "()" | cut -d ' ' -f1 | grep -v "^_")
        ) | fzf | cut -d '=' -f1
    )

    eval $CMD
}

# List and edit cheatsheet
fcheat() {
    file=$(find ~/.config/cheat/tools/* -maxdepth 1 -type f -prune -exec basename {} ';' | sort | uniq | fzf | cut -f 2) || return
	[ -n "$file" ] && cheat --edit "$file"
}

# List workspace projects
fwork() {
    result=$(find ~/desktop/workspace/* -type d -prune -exec basename {} ';' | sort | uniq | nl | fzf | cut -f 2)
    [ -n "$result" ] && cd ~/desktop/workspace/$result
}

# List connected external devices
fdev() {
    result=$(find /run/media/$USER/* -type d -prune -exec basename {} ';' | sort | uniq | nl | fzf | cut -f 2)
    [ -n "$result" ] && cd ~/run/media/$USER/$result
}

# List projects
fproj() {
    result=$(find ~/desktop/projects/* -type d -prune -exec basename {} ';' | sort | uniq | nl | fzf | cut -f 2)
    [ -n "$result" ] && cd ~/desktop/projects/$result
}

# List pdfs
fpdf() {
    result=$(find ~ -type f -name '*.pdf' | fzf --bind "ctrl-r:reload(find -type f -name '*.pdf')" --preview "pdftotext {} - | less")
    [ -n "$result" ] && zathura "$result" &
}

# List tracking spreadsheets (productivity, money ...)
ftrack() {
    file=$(find ~/documents/org/roam/metrics/* -type f -prune -exec basename {} ';' | sort | uniq | nl | fzf | cut -f 2) || return
    [ -n "$file" ] && eval "$EDITOR" "$file"
}

# List clipboard history
fclip() {
    cliphist list | fzf | cliphist decode | wl-copy
}


#########
# Other #
#########

# Browser quicklinks menu
fqli () {
    local options=(" Google" " Google (Private Tab)" " YouTube" " Github" " Github Trending" " Gmail" " Proton Mail" " MEGA" " Open Shopping Websites" " Amazon (US)" " Amazon (PL)" "󰒚 Allegro" "󰒚 OLX" " Helion" " HTB" " THM" " TCM" " OffSec" "󰚌 Root-me" " PentesterLab" " PWNX" " ChatGBT") 
    local choice=$(printf "%s\n" "${options[@]}" | fzf --preview "echo {}") 
    case $choice in
        (" Google") echo -n "Search Google: "
            read query
            if [ -z "$query" ]
            then
                xdg-open "https://www.google.com" &
            else
                xdg-open "https://www.google.com/search?q=$query" &
            fi ;;
        (" Google (Private Tab)") echo -n "Search Google (Private Tab): "
            read query
            if [ -z "$query" ]
            then
                firefox --private-window "https://www.google.com" &
            else
                firefox --private-window "https://www.google.com/search?q=$query" &
            fi ;;
        (" YouTube") echo -n "Search YouTube: "
            read query
            if [ -z "$query" ]
            then
                xdg-open "https://www.youtube.com/feed/subscriptions" &
            else
                xdg-open "https://www.youtube.com/results?search_query=$query" &
            fi ;;
        (" Github") echo -n "Search Github: "
            read query
            if [ -z "$query" ]
            then
                xdg-open "https://github.com" &
            else
                xdg-open "https://github.com/search?q=$query" &
            fi ;;
        (" Github Trending") xdg-open "https://github.com/trending" &
            ;;
        (" Gmail") xdg-open "https://mail.google.com" &
            ;;
        (" Proton Mail") xdg-open "https://mail.proton.me" &
            ;;
        (" MEGA") xdg-open "https://mega.nz" &
            ;;
		(" Open Shopping Websites") echo -n "Search Shopping Websites: "
            read query
            if [ -z "$query" ]
            then
                echo "Search query is empty."
            else
                xdg-open "https://www.amazon.com/s?k=$query" &
                xdg-open "https://www.amazon.pl/s?k=$query" &
                xdg-open "https://allegro.pl/listing?string=$query" &
                xdg-open "https://www.olx.pl/oferty/q-$query/" &
            fi ;;
        (" Amazon (US)") echo -n "Search Amazon (US): "
            read query
            if [ -z "$query" ]
            then
                xdg-open "https://www.amazon.com" &
            else
                xdg-open "https://www.amazon.com/s?k=$query" &
            fi ;;
        (" Amazon (PL)") echo -n "Search Amazon (PL): "
            read query
            if [ -z "$query" ]
            then
                xdg-open "https://www.amazon.pl" &
            else
                xdg-open "https://www.amazon.pl/s?k=$query" &
            fi ;;
        ("󰒚 Allegro") echo -n "Search Allegro: "
            read query
            if [ -z "$query" ]
            then
                xdg-open "https://www.allegro.pl" &
            else
                xdg-open "https://allegro.pl/listing?string=$query" &
            fi ;;
        (" OLX") echo -n "Search OLX: "
            read query
            if [ -z "$query" ]
            then
                xdg-open "https://www.olx.pl" &
            else
                xdg-open "https://www.olx.pl/oferty/q-$query/" &
            fi ;;
        (" Helion") xdg-open "https://helion.pl/kategorie/ksiazki/hacking" &
            ;;
        (" HTB") xdg-open "https://www.hackthebox.eu" &
            ;;
        (" THM") xdg-open "https://tryhackme.com" &
            ;;
        (" TCM") xdg-open "https://academy.tcm-sec.com" &
            ;;
        (" OffSec") xdg-open "https://www.offensive-security.com" &
            ;;
        ("󰚌 Root-me") xdg-open "https://www.root-me.org" &
            ;;
        (" PentesterLab") xdg-open "https://www.pentesterlab.com" &
            ;;
        (" PWNX") xdg-open "https://www.pwnx.io" &
            ;;
        (" ChatGBT") xdg-open "https://www.chat.openai.com" &
            ;;
    esac
}

# Display the directory stack with fzf. Jump to the directory when one selected
fpop() {
    # Only work with alias d (in zsh-aliases) defined as:
    # alias d='dirs -v'
    # for index ({1..9}) alias "$index"="cd +${index}"; unset index
    d | fzf --height="20%" | cut -f 1 | source /dev/stdin
}

# Find in File using ripgrep
fif() {
  if [ ! "$#" -gt 0 ]; then return 1; fi
  rg --files-with-matches --no-messages "$1" \
      | fzf --preview "highlight -O ansi -l {} 2> /dev/null \
      | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' \
      || rg --ignore-case --pretty --context 10 '$1' {}"
}

# Find in file using ripgrep-all
fifa() {
    if [ ! "$#" -gt 0 ]; then return 1; fi
    local file
    file="$(rga --max-count=1 --ignore-case --files-with-matches --no-messages "$*" \
        | fzf-tmux -p +m --preview="rga --ignore-case --pretty --context 10 '"$*"' {}")" \
        && print -z "./$file" || return 1;
}

# Image preview
fimg() {
	EXTERNAL_COLUMNS=235 \
	fzf --preview='kitten icat --clear --transfer-mode=memory --place="80"x"180"@"$(($EXTERNAL_COLUMNS-155))"x2 --align center --stdin=no {} > /dev/tty' --preview-window "right,50%,border-left"
}
