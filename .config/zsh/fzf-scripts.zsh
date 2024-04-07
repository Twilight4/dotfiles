#!/usr/bin/env zsh

####################
# Change directory #
####################

# Search for a file (not hidden) and edit in $EDITOR
ff() {
  file=$(find . -type f -not -path '*/\.*' -not -iname "*.jpg" -not -iname "*.jpeg" -not -iname "*.png" -not -iname "*.gif" \
      | fzf --query="$1" --no-multi --select-1 --exit-0 \
      --reverse --bind "ctrl-q:preview-down,alt-q:preview-up,ctrl-f:preview-page-down,ctrl-b:preview-page-up" --preview 'bat --style=numbers --color=always --line-range :500 {}')
  if [[ -n "$file" ]]; then
    eval "$EDITOR" "$file"
  fi
}

# Find file and cd there
ffh() {
    local file
    local dir
    file=$(fzf +m --reverse --bind "ctrl-q:preview-down,alt-q:preview-up,ctrl-f:preview-page-down,ctrl-b:preview-page-up" --preview "bat --style=numbers --color=always --line-range :500 {}" -q "$1") && dir=$(dirname "$file") && cd "$dir"
    lsd -l --hyperlink=auto
}

# Cd into the selected directory (updated fzf-cd-widget without zle and with lsd)
fzf-cd() {
  setopt localoptions pipefail no_aliases 2> /dev/null
  local dir="$(FZF_DEFAULT_COMMAND=${FZF_ALT_C_COMMAND:-} FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse --walker=dir,follow,hidden --scheme=path --bind=ctrl-z:ignore ${FZF_DEFAULT_OPTS-} ${FZF_ALT_C_OPTS-}" $(__fzfcmd) +m < /dev/tty)"

  cd "$dir" && lsd -l --hyperlink=auto
}


################
# Command Line #
################

# Select file and output using bat
fbat() {
  file=$(find . -type f -not -path '*/\.*' -not -iname "*.jpg" -not -iname "*.jpeg" -not -iname "*.png" -not -iname "*.gif" | fzf --bind "ctrl-q:preview-down,alt-q:preview-up,ctrl-f:preview-page-down,ctrl-b:preview-page-up" --query="$1" --no-multi --select-1 --exit-0 \
      --reverse --preview 'bat --style=numbers --color=always --line-range :500 {}')
  if [[ -n "$file" ]]; then
    bat --style header --color always --style snip --style changes --style header "$file"
  fi
}

# Copy file path to clipboard (without hidden files)
fccp() {
  file=$(find ~ -type f -not -path '*/\.*' | fzf --bind "ctrl-q:preview-down,alt-q:preview-up,ctrl-f:preview-page-down,ctrl-b:preview-page-up" --query="$1" --no-multi --select-1 --exit-0 \
      --reverse --preview 'bat --style=numbers --color=always --line-range :500 {}')
  if [[ -n "$file" ]]; then
    printf "%s" "$file" | wl-copy -n  # Copy path to clipboard
    echo "$file copied to clipboard."
  fi
}

# Image preview
fimg() {
  find . -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.bmp" \) | fzf --preview='kitten icat --clear --transfer-mode=memory --place="80"x"180"@"$((200-120))"x2 --align center --stdin=no {}' --preview-window "right,50%,border-left"
}

frm() {
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
}

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
fman() {
    MAN="/usr/bin/man"
    if [ -n "$1" ]; then
        $MAN "$@"
        return $?
    else
        $MAN -k . | fzf --reverse --prompt='Man> ' --preview="echo {1} | sed 's/(.*//' | xargs $MAN -P cat" | awk '{print $1}' | sed 's/(.*//' | xargs $MAN
        return $?
    fi
}

# i.e. fzf-eval ls
fzf-eval() {
    echo | fzf -q "$*" --preview-window=up:99% --preview="eval {q}"
}

# Repeat history, assumes zsh
fhistory() {
    print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}

# Search env variables
fvars() {
    local out
    out=$(env | fzf)
    echo $(echo $out | cut -d= -f2)
}


####################
# Package Managers #
####################

# Pacman
fpac() {
    pacman -Slq | fzf --multi --reverse --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S
}

fpar() {
    paru -Slq | fzf --multi --reverse --preview 'paru -Si {1}' | xargs -ro paru -S
}

fparr() {
    paru -Qq | fzf --multi --reverse --preview 'paru -Si {1}' | xargs -ro paru -Rns
}

# Apt-get
fapti() {
    apt-cache search . | cut -d' ' -f1 | fzf --multi --reverse --preview 'apt-cache show {1}' | xargs -r sudo apt-get install
}

faptr() {
    dpkg --get-selections | awk '$2 == "install" { print $1 }' | fzf --multi --reverse --preview 'apt-cache show {1}' | xargs -ro sudo apt-get purge
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
                --bind "alt-j:preview-down,alt-k:preview-up,ctrl-f:preview-page-down,ctrl-b:preview-page-up,ctrl-m:execute:
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

# List cheatsheets and edit
fchtce() {
    file=$(cheat -l -t tools | tail -n +2 | cut -d' ' -f1 | sort | uniq | fzf --preview 'command bat --style header --style snip --style changes --style header --plain --language=help --color=always ~/.config/cheat/tools/{}') || return
	[ -n "$file" ] && command cheat --edit "$file"
}

# List org notes and edit
fchtoe() {
  file=$(find ~/documents/org/roam -type f -name "*.org" -printf "%P\n" | sort | uniq | fzf --preview "sed -e 's/^\* .*$/\x1b[94m&\x1b[0m/' -e 's/^\*\*.*$/\x1b[96m&\x1b[0m/' -e 's/=\([^=]*\)=/\o033[1;32m\1\o033[0m/g; s/^\( \{0,6\}\)-/•/g' -e '/^\(:PROPERTIES:\|:ID:\|:END:\|#\+date:\)/d' ~/documents/org/roam/{} | command bat --language=org --style=plain --color=always" --preview-window=right:50%:wrap)

  if [[ -n "$file" ]]; then
    eval $EDITOR ~/documents/org/roam/"$file"
  fi
}

# List org notes based on content and cat
frgo() {
  pushd ~/documents/org/roam/ &> /dev/null

  if [ ! "$#" -gt 0 ]; then return 1; fi
  selected_file=$(rg --files-with-matches --no-messages "$1" \
    | fzf --preview "highlight -O ansi -l {} 2> /dev/null \
    | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' \
    || rg --ignore-case --pretty --context 10 '$1' {}")

  if [[ -n "$selected_file" ]]; then
    sed -e 's/^\* .*$/\x1b[94m&\x1b[0m/' -e 's/^\*\*.*$/\x1b[96m&\x1b[0m/' -e 's/=\([^=]*\)=/\o033[1;32m\1\o033[0m/g; s/^\( \{0,6\}\)-/•/g' -e '/^\(:PROPERTIES:\|:ID:\|:END:\|#\+date:\)/d' "$selected_file" | command bat --language=org --style=plain --color=always
  fi

  popd &> /dev/null
}

# List org notes based on content and edit
frgoe() {
  pushd ~/documents/org/roam/ &> /dev/null

  if [ ! "$#" -gt 0 ]; then return 1; fi
  selected_file=$(rg --files-with-matches --no-messages "$1" \
    | fzf --preview "highlight -O ansi -l {} 2> /dev/null \
    | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' \
    || rg --ignore-case --pretty --context 10 '$1' {}")

  if [ -n "$selected_file" ]; then
    eval $EDITOR "$selected_file"
  fi

  popd &> /dev/null
}

# List cheatsheets and cat with preview
fchtc() {
  file=$(cheat -l -t tools | tail -n +2 | cut -d' ' -f1 | sort | uniq | fzf --preview 'command bat --style header --style snip --style changes --style header --plain --language=help --color=always ~/.config/cheat/tools/{}') || return
	[ -n "$file" ] && command cheat "$file" | bat --style header --style snip --style changes --style header --plain --language=help
}

# List org notes and cat
fchto() {
  file=$(find ~/documents/org/roam -type f -name "*.org" -printf "%P\n" | sort | uniq | fzf --preview "sed -e 's/^\* .*$/\x1b[94m&\x1b[0m/' -e 's/^\*\*.*$/\x1b[96m&\x1b[0m/' -e 's/=\([^=]*\)=/\o033[1;32m\1\o033[0m/g; s/^\( \{0,6\}\)-/•/g' -e '/^\(:PROPERTIES:\|:ID:\|:END:\|#\+date:\)/d' ~/documents/org/roam/{} | command bat --language=org --style=plain --color=always" --preview-window=right:50%:wrap) || return
	[ -n "$file" ] && command sed -e 's/^\* .*$/\x1b[94m&\x1b[0m/' -e 's/^\*\*.*$/\x1b[96m&\x1b[0m/' -e 's/=\([^=]*\)=/\o033[1;32m\1\o033[0m/g; s/^\( \{0,6\}\)-/•/g' -e '/^\(:PROPERTIES:\|:ID:\|:END:\|#\+date:\)/d' ~/documents/org/roam/"$file" | command bat --language=org --style=plain --color=always
}

# List specific org notes and edit
fnp() {
  file=$(find ~/documents/org/roam/nothing-personal/ -type f -name "*.org" -printf "%P\n" | sort | uniq | fzf --preview "sed -e 's/^\* .*$/\x1b[94m&\x1b[0m/' -e 's/^\*\*.*$/\x1b[96m&\x1b[0m/' -e 's/=\([^=]*\)=/\o033[1;32m\1\o033[0m/g; s/^\( \{0,6\}\)-/•/g' -e '/^\(:PROPERTIES:\|:ID:\|:END:\|#\+date:\)/d' ~/documents/org/roam/nothing-personal/{} | command bat --language=org --style=plain --color=always" --preview-window=right:50%:wrap)

  if [[ -n "$file" ]]; then
    eval $EDITOR ~/documents/org/roam/nothing-personal/"$file"
  fi
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

# List templates for work
ftemp() {
    result=$(find ~/documents/org/projects/ -type f -name "*.org" -printf "%P\n" | sort | uniq | fzf --preview "sed -e 's/^\* .*$/\x1b[94m&\x1b[0m/' -e 's/^\*\*.*$/\x1b[96m&\x1b[0m/' -e 's/=\([^=]*\)=/\o033[1;32m\1\o033[0m/g; s/^\( \{0,6\}\)-/•/g' -e '/^\(:PROPERTIES:\|:ID:\|:END:\|#\+date:\)/d' ~/documents/org/projects/{} | command bat --language=org --style=plain --color=always" --preview-window=right:50%:wrap) || return

    [ -n "$result" ] && eval "$EDITOR" ~/documents/org/projects/"$result"
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

# Find in File using ripgrep and open in editor
frg() {
  if [ ! "$#" -gt 0 ]; then return 1; fi
  selected_file=$(rg --files-with-matches --no-messages "$1" \
    | fzf --preview "highlight -O ansi -l {} 2> /dev/null \
    | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' \
    || rg --ignore-case --pretty --context 10 '$1' {}")

  if [ -n "$selected_file" ]; then
    eval $EDITOR "$selected_file"
  fi
}

# Find in file using ripgrep-all
fifa() {
    if [ ! "$#" -gt 0 ]; then return 1; fi
    local file
    file="$(rga --max-count=1 --ignore-case --files-with-matches --no-messages "$*" \
        | fzf-tmux -p +m --preview="rga --ignore-case --pretty --context 10 '"$*"' {}")" \
        && print -z "./$file" || return 1;
}
