#!/usr/bin/env zsh

####################
# Change directory #
####################

# Search for a file (not hidden) and edit in $EDITOR
ff() {
  file=$(find . -type f -not -path '*/\.*' -not -iname "*.mp4" -not -iname "*.URL" -not -iname "*.webm" -not -iname "*.pdf" -not -iname "*.exe" -not -iname "*.zip" -not -iname "*.gzip" -not -iname "*.vhd" -not -iname "*.tar.xz" -not -iname "*.docx" -not -iname "*.jpg" -not -iname "*.jpeg" -not -iname "*.png" -not -iname "*.gif" \
      | fzf --query="$1" --no-multi --select-1 --exit-0 --reverse --preview 'bat --style=snip --color=always --line-range :500 {}')
  if [[ -n "$file" ]]; then
    eval "$EDITOR" "$file"
  fi
}

# Find file and cd there
ffh() {
    local file
    local dir
    file=$(fzf +m --reverse --preview "bat --style=snip --color=always --line-range :500 {}" -q "$1") && dir=$(dirname "$file") && cd "$dir"
    lsd -l --hyperlink=auto
}

# Cd into the selected directory (updated fzf-cd-widget without zle and with lsd)
fzf-cd() {
  setopt localoptions pipefail no_aliases 2> /dev/null
  local dir="$(FZF_DEFAULT_COMMAND=${FZF_ALT_C_COMMAND:-} FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse --walker=dir,follow,hidden --scheme=path --bind=ctrl-z:ignore ${FZF_DEFAULT_OPTS-} ${FZF_ALT_C_OPTS-}" $(__fzfcmd) +m < /dev/tty)"

  cd "$dir" && lsd -l --hyperlink=auto
}

# Cd into the selected directory globally
fzf-cd-global() {
  pushd ~/ &> /dev/null

  setopt localoptions pipefail no_aliases 2> /dev/null
  local dir="$(FZF_DEFAULT_COMMAND=${FZF_ALT_C_COMMAND:-} FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse --walker=dir,follow,hidden --scheme=path --bind=ctrl-z:ignore ${FZF_DEFAULT_OPTS-} ${FZF_ALT_C_OPTS-}" $(__fzfcmd) +m < /dev/tty)"

  cd "$dir" && lsd -l --hyperlink=auto
}


################
# Command Line #
################

# Select file and output using bat
fbat() {
  file=$(find . -type f -not -path '*/\.*' -not -iname "*.mp4" -not -iname "*.ttf" -not -iname "*.URL" -not -iname "*.webm" -not -iname "*.pdf" -not -iname "*.exe" -not -iname "*.zip" -not -iname "*.gzip" -not -iname "*.vhd" -not -iname "*.tar.xz" -not -iname "*.docx" -not -iname "*.jpg" -not -iname "*.jpeg" -not -iname "*.png" -not -iname "*.gif" | fzf --query="$1" --no-multi --select-1 --exit-0 \
      --reverse --preview 'bat --style=snip --color=always --line-range :500 {}')
  if [[ -n "$file" ]]; then
    bat --color=always --style header,grid,changes "$file"
  fi
}

# Copy file path to clipboard
fccp() {
  file=$(find ~ -type f | fzf --query="$1" --no-multi --select-1 --exit-0 \
      --reverse --preview 'bat --style=snip --color=always --line-range :500 {}')
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
    if [[ "$#" -eq 0 ]]; then
        # prompt user interactively to select multiple files or directories with tab + fuzzy search
        SOURCES=$(find . -maxdepth 1 -printf "%P\n" | fzf --multi)
        # we use xargs to capture filenames with spaces in them properly
        echo "$SOURCES" | xargs -I '{}' trash -rfv {}
    else
        echo "There's error happened for some reason. Files not removed. Do you have trash installed?"
    fi
}

fmv() {
    local SOURCES
    local TARGET
    if [[ "$#" -eq 0 ]]; then
        vared -p 'Files destination: ' -c TARGET
        if [ -z "$TARGET" ]; then
            echo 'no target specified'
            return 1
        fi

        # This corrects issue where directory is not found as ~ is
        # not expanded properly when stored directly from user input
        if echo "$TARGET" | grep -q "~"; then
            TARGET=$(echo $TARGET | sed 's/~//')
            TARGET=~/$TARGET
        fi

        # Include both files and directories
        SOURCES=$(find . -maxdepth 1 -printf "%P\n" | fzf --multi)
        # We use xargs to capture filenames with spaces in them properly
        echo "$SOURCES" | xargs -I '{}' mv -v {} "$TARGET"
    else
        echo "There's error happened for some reason. Files not moved."
    fi
}

fcp() {
    local SOURCES
    local TARGET
    if [[ "$#" -eq 0 ]]; then
        vared -p 'Files destination: ' -c TARGET
        if [ -z "$TARGET" ]; then
            echo 'no target specified'
            return 1
        fi

        # This corrects issue where directory is not found as ~ is
        # not expanded properly when stored directly from user input
        if echo "$TARGET" | grep -q "~"; then
            TARGET=$(echo $TARGET | sed 's/~//')
            TARGET=~/$TARGET
        fi

        # Include both files and directories
        SOURCES=$(find . -maxdepth 1 -printf "%P\n" | fzf --multi)
        # We use xargs to capture filenames with spaces in them properly
        echo "$SOURCES" | xargs -I '{}' xcp -r -v {} "$TARGET"
    else
        echo "There's error happened for some reason. Files not copied. Do you have xcp installed?"
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

# Apt package manager
fapti() {
    selected_packages=$(apt-cache search . | cut -d' ' -f1 | fzf --multi --reverse --preview 'apt-cache show {1}')

    # Check if package to install is selected
    if [ -z "$selected_packages" ]; then
        echo "No package selected. Exiting."
        return
    fi

    # Confirmation for installing the package
    echo "You have selected the following packages for installation: $selected_packages"
    echo -n "Are you sure you want to install these packages? (y/N): "
    read confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "Operation cancelled."
        return
    fi

    # Install the selected package(s)
    sudo apt-get update && echo "$selected_packages" | xargs -ro sudo apt-get install -y

    # Check if installation was successful
    if [ $? -eq 0 ]; then
        echo
        echo "Installation completed successfully."
    else
        echo
        echo "Installation failed. Please check the error messages above."
    fi
}

faptr() {
    selected_packages=$(dpkg --get-selections | awk '$2 == "install" { print $1 }' | fzf --multi --reverse --preview 'apt-cache show {1}')

    # Check if package to uninstall is selected
    if [ -z "$selected_packages" ]; then
        echo "No package selected. Exiting."
        return
    fi

    # Confirmation for uninstalling the package
    echo "You have selected the following packages for removal: $selected_packages"
    echo -n "Are you sure you want to purge these packages? (y/N): "
    read confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "Operation cancelled."
        return
    fi

    # Uninstall the package
    sudo apt-get update && echo "$selected_packages" | xargs -ro sudo apt-get purge -y

    # Check if purge was successful
    if [ $? -eq 0 ]; then
        echo
        echo "Purging completed successfully."
    else
        echo
        echo "Purging failed. Please check the error messages above."
    fi

    # Search for leftovers
    echo
    echo -n "Do you want to search for leftover files related to the removed packages? (y/N): " 
    read confirm_search
    if [[ "$confirm_search" =~ ^[Yy]$ ]]; then
        echo "Searching for leftover files..."
        echo
        echo "$selected_packages" | while read -r package; do
            sudo find / -name "*$package*"
        done
    else
        echo "Skipping search for leftover files."
    fi

    echo
    echo "Optional additional cleanup steps:"
    echo "Run 'cleanup' to run remove unused dependencies"
    echo "Run 'aptcache' to check the size of package cache"
    echo "Run 'aptcache-clean' to clean all package cache"
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
                --bind "ctrl-m:execute:
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
    file=$(cheat -l -t tools | tail -n +2 | cut -d' ' -f1 | sort | uniq | fzf --preview 'command bat --style=snip --language=help --color=always ~/.config/cheat/tools/{}') || return
	[ -n "$file" ] && command cheat --edit "$file"
}

# List org notes and edit
fchtoe() {
  file=$(find ~/documents/org/roam -type f -name "*.org" -printf "%P\n" | sort | uniq | fzf --preview "sed -e 's/^\* .*$/\x1b[94m&\x1b[0m/' -e 's/^\*\*.*$/\x1b[96m&\x1b[0m/' -e 's/=\([^=]*\)=/\o033[1;32m\1\o033[0m/g; s/^\( \{0,6\}\)-/•/g' -e '/^\(:PROPERTIES:\|:ID:\|:END:\|#\+date:\)/d' ~/documents/org/roam/{} | command bat --language=org --style=snip --color=always" --preview-window=right:50%:wrap)

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
    sed -e 's/^\* .*$/\x1b[94m&\x1b[0m/' -e 's/^\*\*.*$/\x1b[96m&\x1b[0m/' -e 's/=\([^=]*\)=/\o033[1;32m\1\o033[0m/g; s/^\( \{0,6\}\)-/•/g' -e '/^\(:PROPERTIES:\|:ID:\|:END:\|#\+date:\)/d' "$selected_file" | command bat --language=org --style=snip --color=always
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
  file=$(cheat -l -t tools | tail -n +2 | cut -d' ' -f1 | sort | uniq | fzf --preview 'command bat --style=snip --language=help --color=always ~/.config/cheat/tools/{}') || return
	[ -n "$file" ] && command cheat "$file" | bat --style=snip --color=always --language=help
}

# List org notes and cat
fchto() {
  file=$(find ~/documents/org/roam -type f -name "*.org" -printf "%P\n" | sort | uniq | fzf --preview "sed -e 's/^\* .*$/\x1b[94m&\x1b[0m/' -e 's/^\*\*.*$/\x1b[96m&\x1b[0m/' -e 's/=\([^=]*\)=/\o033[1;32m\1\o033[0m/g; s/^\( \{0,6\}\)-/•/g' -e '/^\(:PROPERTIES:\|:ID:\|:END:\|#\+date:\)/d' ~/documents/org/roam/{} | command bat --language=org --style=snip --color=always" --preview-window=right:50%:wrap) || return
	[ -n "$file" ] && command sed -e 's/^\* .*$/\x1b[94m&\x1b[0m/' -e 's/^\*\*.*$/\x1b[96m&\x1b[0m/' -e 's/=\([^=]*\)=/\o033[1;32m\1\o033[0m/g; s/^\( \{0,6\}\)-/•/g' -e '/^\(:PROPERTIES:\|:ID:\|:END:\|#\+date:\)/d' ~/documents/org/roam/"$file" | command bat --language=org --style=snip --color=always
}

# List specific org notes and edit
fnp() {
  file=$(find ~/documents/org/roam/nothing-personal/ -type f -name "*.org" -printf "%P\n" | sort | uniq | fzf --preview "sed -e 's/^\* .*$/\x1b[94m&\x1b[0m/' -e 's/^\*\*.*$/\x1b[96m&\x1b[0m/' -e 's/=\([^=]*\)=/\o033[1;32m\1\o033[0m/g; s/^\( \{0,6\}\)-/•/g' -e '/^\(:PROPERTIES:\|:ID:\|:END:\|#\+date:\)/d' ~/documents/org/roam/nothing-personal/{} | command bat --language=org --style=snip --color=always" --preview-window=right:50%:wrap)

  if [[ -n "$file" ]]; then
    eval $EDITOR ~/documents/org/roam/nothing-personal/"$file"
  fi
}

# List workspace git repos
fwork() {
    result=$(find ~/desktop/workspace/* -type d -prune -exec basename {} ';' | sort | uniq | nl | fzf | cut -f 2)
    [ -n "$result" ] && cd ~/desktop/workspace/$result ; lsd -l --hyperlink=auto
}

# List connected external devices
fdev() {
    result=$(find /run/media/$USER/* -type d -prune -exec basename {} ';' | sort | uniq | nl | fzf | cut -f 2)
    [ -n "$result" ] && cd ~/run/media/$USER/$result ; lsd -l --hyperlink=auto
}

# List projects
fproj() {
    result=$(find ~/desktop/projects/* -type d -prune -exec basename {} ';' | sort | uniq | nl | fzf | cut -f 2)
    [ -n "$result" ] && cd ~/desktop/projects/$result ; lsd -l --hyperlink=auto
}

# List current findings reports
frep() {
    result=$(find ~/documents/org/reports/ -type f -name "*.org" -printf "%P\n" | sort | uniq | fzf --preview "sed -e 's/^\* .*$/\x1b[94m&\x1b[0m/' -e 's/^\*\*.*$/\x1b[96m&\x1b[0m/' -e 's/=\([^=]*\)=/\o033[1;32m\1\o033[0m/g; s/^\( \{0,6\}\)-/•/g' -e '/^\(:PROPERTIES:\|:ID:\|:END:\|#\+date:\)/d' ~/documents/org/reports/{} | command bat --language=org --style=snip --color=always" --preview-window=right:50%:wrap) || return

    [ -n "$result" ] && eval "$EDITOR" ~/documents/org/reports/"$result"
}

# List pdfs
fpdf() {
    result=$(find ~ -type f -not -path '*/\.*' -name '*.pdf' | fzf --bind "ctrl-r:reload(find -type f -name '*.pdf')" --preview "pdftotext {} - | less")
    [ -n "$result" ] && zathura "$result" &
}

# List vpn files
fovpn() {
    file=$(find ~/documents/openvpn/* -type f -name '*.ovpn' -prune -exec basename {} ';' | sort | uniq | nl | fzf | cut -f 2) || return
    [ -n "$file" ] && sudo openvpn "$HOME"/documents/openvpn/"$file"
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
frga() {
    if [ ! "$#" -gt 0 ]; then return 1; fi
    local file
    file="$(rg --hidden -i --max-count=1 --ignore-case --files-with-matches --no-messages "$*" \
        | fzf-tmux -p +m --preview="rg --hidden -i --ignore-case --pretty --context 10 '"$*"' {}")" \
        && print -z "./$file" || return 1;
}
