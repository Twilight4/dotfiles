#!/usr/bin/env zsh

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

# git log browser with FZF
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

# git branch
fgb() {
  local branches branch
  branches=$(git --no-pager branch -vv) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
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
    [ -n "$file" ] && emacsclient -nw "$file"
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
    local options=(" Google" " Google (Private Tab)" " YouTube" " Github" " Github Trending" " Gmail" " Proton Mail" " MEGA" " Proton VPN" " Open Shopping Websites" " Amazon (US)" " Amazon (PL)" "󰒚 Allegro" "󰒚 OLX" " Helion" " HTB" " THM" " TCM" " OffSec" "󰚌 Root-me" " PentesterLab" " PWNX" " ChatGBT") 
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
        (" Proton VPN") xdg-open "https://account.proton.me/vpn" &
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

# Better cd-ls navigation
fcd() {
    local dir
    dir=$(find ${1:-.} -type d -not -path '*/\.*' 2> /dev/null | fzf +m) && cd "$dir"
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
