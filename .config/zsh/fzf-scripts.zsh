#!/usr/bin/env zsh

####################
# Change directory #
####################

# Search for a file (not hidden) and edit in $EDITOR
ff() {
  file=$(find . -type f -not -path '*/\.*' -not -iname "*.mp4" -not -iname "*.URL" -not -iname "*.webm" -not -iname "*.pdf" -not -iname "*.exe" -not -iname "*.zip" -not -iname "*.gzip" -not -iname "*.vhd" -not -iname "*.tar.xz" -not -iname "*.docx" -not -iname "*.jpg" -not -iname "*.jpeg" -not -iname "*.png" -not -iname "*.gif" -printf "%P\n" \
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

fkill() {
    if [[ $(uname) = Linux ]]; then
        pid_col=2
        pids=$(ps -f -u "$USER" | sed 1d | fzf --multi | tr -s "[:blank:]" | cut -d' ' -f"$pid_col")
    else
        echo 'Error: unknown platform'
        return
    fi

    if [[ -n "$pids" ]]; then
        echo "$pids" | xargs kill -9 "$@"
    fi
}

# List of port opens
fports() {
    sudo netstat -tulpn | grep LISTEN | fzf;
}

# Select file and output using bat
fbat() {
  file=$(find . -type f -not -path '*/\.*' -not -iname "*.mp4" -not -iname "*.ttf" -not -iname "*.URL" -not -iname "*.webm" -not -iname "*.pdf" -not -iname "*.exe" -not -iname "*.zip" -not -iname "*.gzip" -not -iname "*.vhd" -not -iname "*.tar.xz" -not -iname "*.docx" -not -iname "*.jpg" -not -iname "*.jpeg" -not -iname "*.png" -not -iname "*.gif" | sed 's|^\./||' | fzf --query="$1" --no-multi --select-1 --exit-0 \
      --reverse --preview 'bat --style=snip --color=always --line-range :500 ./{}')
  if [[ -n "$file" ]]; then
    bat --color=always --style header,grid,changes "./$file"
  fi
}

# Copy file path to clipboard
fccp() {
  file=$(find ~ -type f | fzf --query="$1" --no-multi --select-1 --exit-0 \
      --reverse --preview 'bat --style=snip --color=always --line-range :500 {}')
  if [[ -n "$file" ]]; then
    printf "%s" "$file" | wl-copy -n  # Copy path to clipboard
    echo -e "\e[34m$file\e[0m copied to clipboard."
  else
    echo -e "\e[31mNo file selected.\e[0m"
  fi
}

# Image preview
fimg() {
  find . -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.bmp" \) -printf "%f\n" | fzf --preview='kitten icat --clear --transfer-mode=memory --place="80"x"180"@"$((200-120))"x2 --align center --stdin=no {}' --preview-window "right,50%,border-left"
}

frm() {
    local SOURCES
    if [[ "$#" -eq 0 ]]; then
        # Prompt user interactively to select multiple files or directories with tab + fuzzy search
        SOURCES=$(find . -maxdepth 1 -mindepth 1 -printf "%P\n" | fzf --multi)
        # Check if any files were selected
        if [[ -n "$SOURCES" ]]; then
            # Use xargs to capture filenames with spaces in them properly
            echo "$SOURCES" | while IFS= read -r file; do
                \trash -rfv "$file"
                if [[ $? -eq 0 ]]; then
                else
                    echo -e "\e[31m[X] Error occurred while trashing '\e[0m\e[33m$file\e[0m\e[31m'.\e[0m"
                    echo -e "\e[31m[X] If it's Permission denied, run: \e[0m\e[32msudo trash -rf $file\e[0m\e[31m\e[0m"
                fi
            done
        else
            echo -e "\e[31m[X] No files selected.\e[0m"
        fi
    else
        echo -e "\e[31m[X] There's an error. Files not removed. Do you have trash installed?\e[0m"
    fi
}

fmv() {
    local SOURCES
    local TARGET
    if [[ "$#" -eq 0 ]]; then
        vared -p 'Files destination: ' -c TARGET
        if [ -z "$TARGET" ]; then
            echo -e "\e[31mNo target specified.\e[0m"
            return 1
        fi

        # This corrects the issue where the directory is not found as ~ is
        # not expanded properly when stored directly from user input
        if echo "$TARGET" | grep -q "~"; then
            TARGET=$(echo "$TARGET" | sed 's/~//')
            TARGET=~/"$TARGET"
        fi

        # Include both files and directories
        SOURCES=$(find . -maxdepth 1 -mindepth 1 -printf "%P\n" | fzf --multi)
        # Check if any files were selected
        if [[ -n "$SOURCES" ]]; then
            # Use xargs to capture filenames with spaces in them properly
            echo "$SOURCES" | while IFS= read -r file; do
                mv "$file" "$TARGET"
                if [[ $? -eq 0 ]]; then
                    echo -e "\e[34mmoved: '\e[0m\e[33m$file\e[0m\e[34m' -> '\e[0m\e[33m$TARGET$file/\e[0m\e[34m'\e[0m"
                else
                    echo -e "\e[31m[X] Error occurred while moving '\e[0m\e[33m$file\e[0m\e[31m'.\e[0m"
                fi
            done
        else
            echo -e "\e[31m[X] No files selected.\e[0m"
        fi
    else
        echo -e "\e[31m[X] There's an error. Files not moved.\e[0m"
    fi
}

fcp() {
    local SOURCES
    local TARGET
    if [[ "$#" -eq 0 ]]; then
        vared -p 'Files destination: ' -c TARGET
        if [ -z "$TARGET" ]; then
            echo -e "\e[31mNo target specified.\e[0m"
            return 1
        fi

        # This corrects the issue where the directory is not found as ~ is
        # not expanded properly when stored directly from user input
        if echo "$TARGET" | grep -q "~"; then
            TARGET=$(echo "$TARGET" | sed 's/~//')
            TARGET=~/"$TARGET"
        fi

        # Include both files and directories
        SOURCES=$(find . -maxdepth 1 -mindepth 1 -printf "%P\n" | fzf --multi)
        # Check if any files were selected
        if [[ -n "$SOURCES" ]]; then
            # Use xargs to capture filenames with spaces in them properly
            echo "$SOURCES" | while IFS= read -r file; do
                xcp -r "$file" "$TARGET"
                if [[ $? -eq 0 ]]; then
                    echo -e "\e[34mcopied: '\e[0m\e[33m$file\e[0m\e[34m' -> '\e[0m\e[33m$TARGET$file/\e[0m\e[34m'\e[0m"
                else
                    echo -e "\e[31m[X] Error occurred while copying '\e[0m\e[33m$file\e[0m\e[31m'.\e[0m"
                fi
            done
        else
            echo -e "\e[31m[X] No files selected.\e[0m"
        fi
    else
        echo -e "\e[31m[X] There's an error. Files not copied. Do you have xcp installed?\e[0m"
    fi
}

# List recently edited files using fasd and pipe to fzf for selection
frec() {
  local file=$(fasd -Rlf | fzf --reverse --preview 'bat --style=snip --color=always --line-range :500 {}')

  # If a file is selected, convert it back to the full path and open it in Neovim
  [[ -n "$file" ]] && nvim "${file/#~/$HOME}"
}

# list recently visited directories using fasd and pipe to fzf for selection
frecd() {
  local file=$(fasd -rld | fzf --reverse --preview 'exa --tree --icons --group-directories-first --git-ignore --level 2 --color=always {} | head -n 100')

  # if a directory is selected, move into it
  [[ -n "$file" ]] && cd "$file" ; lsd -l --hyperlink=auto
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

# Pacman package manager
fpars() {
    selected_packages=$(paru -Slq | fzf --multi --reverse --preview 'paru -Si {1}')

    # Check if package to install is selected
    if [ -z "$selected_packages" ]; then
        echo -e "\e[31mNo package selected. Exiting.\e[0m"
        return
    fi

    # Confirmation for installing the package
    echo -e "\e[34mYou have selected the following packages for installation: \e[0m\e[33m$selected_packages\e[0m"
    echo -ne "\e[34mAre you sure you want to install these packages? (y/N): \e[0m"
    read confirm
    echo
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo -e "\e[31mOperation cancelled.\e[0m"
        return
    fi

    # Install the selected package(s)
    echo "$selected_packages" | xargs -ro paru -S

    # Check if installation was successful
    if [ $? -eq 0 ]; then
        echo
        echo -e "\e[32mInstallation completed successfully.\e[0m"
    else
        echo
        echo -e "\e[31mInstallation failed. Please check the error messages above.\e[0m"
    fi
}

fparr() {
    # List all explicitly installed packages and use fzf to select packages to uninstall
    selected_packages=$(paru -Qe | awk '{print $1}' | fzf --multi --reverse --preview 'paru -Qi {1}')

    # Check if package to uninstall is selected
    if [ -z "$selected_packages" ]; then
        echo -e "\e[31mNo package selected. Exiting.\e[0m"
        return
    fi

    # Confirmation for uninstalling the package
    echo -e "\e[34mYou have selected the following packages for removal: \e[0m\e[33m$selected_packages\e[0m"
    echo -ne "\e[34mAre you sure you want to remove these packages? (y/N): \e[0m"
    read confirm
    echo
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo -e "\e[31mOperation cancelled.\e[0m"
        return
    fi

    # Uninstall the packages
    echo "$selected_packages" | xargs -ro sudo paru -Rns

    # Check if removal was successful
    if [ $? -eq 0 ]; then
        echo
        echo -e "\e[32mRemoval completed successfully.\e[0m"
    else
        echo
        echo -e "\e[31mRemoval failed. Please check the error messages above.\e[0m"
    fi

    # Search for leftover files
    echo
    echo -ne "\e[34mDo you want to search for leftover files related to the removed packages? (y/N): \e[0m"
    read confirm_search
    if [[ "$confirm_search" =~ ^[Yy]$ ]]; then
        echo -e "\e[34mSearching for leftover files...\e[0m"
        echo
        echo "$selected_packages" | while read -r package; do
            sudo fd "$package" /
        done
    else
        echo -e "\e[31mSkipping search for leftover files.\e[0m"
    fi

    echo
    echo -e "\e[34mOptional additional cleanup steps:\e[0m"
    echo -e "\e[32mRun 'paru -Sc' to clean the package cache\e[0m"
    echo -e "\e[32mRun 'paru -Rns \$(paru -Qdtq)' to remove unused dependencies\e[0m"
}

# Apt package manager
fapti() {
    selected_packages=$(apt-cache search . | cut -d' ' -f1 | fzf --multi --reverse --preview 'apt-cache show {1}')

    # Check if package to install is selected
    if [ -z "$selected_packages" ]; then
        echo -e "\e[31mNo package selected. Exiting.\e[0m"
        return
    fi

    # Confirmation for installing the package
    echo -e "\e[34mYou have selected the following packages for installation: \e[0m\e[33m$selected_packages\e[0m"
    echo -ne "\e[34mAre you sure you want to install these packages? (y/N): \e[0m"
    read confirm
    echo
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo -e "\e[31mOperation cancelled.\e[0m"
        return
    fi

    # Install the selected package(s)
    sudo apt-get update && echo "$selected_packages" | xargs -ro sudo apt-get install -y

    # Check if installation was successful
    if [ $? -eq 0 ]; then
        echo
        echo -e "\e[32mInstallation completed successfully.\e[0m"
    else
        echo
        echo -e "\e[31mInstallation failed. Please check the error messages above.\e[0m"
    fi
}

faptr() {
    selected_packages=$(dpkg --get-selections | awk '$2 == "install" { print $1 }' | fzf --multi --reverse --preview 'apt-cache show {1}')

    # Check if package to uninstall is selected
    if [ -z "$selected_packages" ]; then
        echo -e "\e[31mNo package selected. Exiting.\e[0m"
        return
    fi

    # Confirmation for uninstalling the package
    echo -e "\e[34mYou have selected the following packages for removal: \e[0m\e[33m$selected_packages\e[0m"
    echo -ne "\e[34mAre you sure you want to purge these packages? (y/N): \e[0m"
    read confirm
    echo
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo -e "\e[31mOperation cancelled.\e[0m"
        return
    fi

    # Uninstall the package
    sudo apt-get update && echo "$selected_packages" | xargs -ro sudo apt-get purge -y

    # Check if purge was successful
    if [ $? -eq 0 ]; then
        echo
        echo -e "\e[32mPurging completed successfully.\e[0m"
    else
        echo
        echo -e "\e[31mPurging failed. Please check the error messages above.\e[0m"
    fi

    # Search for leftovers
    echo
    echo -ne "\e[34mDo you want to search for leftover files related to the removed packages? (y/N): \e[0m" 
    read confirm_search
    if [[ "$confirm_search" =~ ^[Yy]$ ]]; then
        echo -e "\e[34mSearching for leftover files...\e[0m"
        echo
        echo "$selected_packages" | while read -r package; do
            sudo fd "$package" /
        done
    else
        echo -e "\e[31mSkipping search for leftover files.\e[0m"
    fi

    echo
    echo -e "\e[34mOptional additional cleanup steps:\e[0m"
    echo -e "\e[32mRun 'cleanup' to remove unused dependencies\e[0m"
    echo -e "\e[32mRun 'aptcache' to check the size of package cache\e[0m"
    echo -e "\e[32mRun 'aptcache-clean' to clean all package cache\e[0m"
}


#######
# Git #
#######
# Command to quickly select files to add, ask for commit message and push changes
fgm() {
  # Fuzzy-find files to add
  local files_to_add
  files_to_add=$(git status -s | awk '{print $2}' | fzf -m --preview 'git diff --color=always {}')

  # Add selected files
  if [ -n "$files_to_add" ]; then
    echo "Adding files:"
    echo "$files_to_add"
    git add $=files_to_add  # Use $= to handle filenames with spaces in Zsh
  else
    echo "No files selected. Exiting."
    return 1
  fi

  # Prompt for commit message
  local commit_message
  echo "\nEnter commit message:"  # Print the prompt on a new line
  read "commit_message?>> "      # Use ">> " as the input prompt

  # Commit changes
  if [ -n "$commit_message" ]; then
    git commit -m "$commit_message"
  else
    echo "No commit message provided. Exiting."
    return 1
  fi

  # Push changes
  echo "\nPushing changes to remote repository..."
  git push
}

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


##########
# Docker #
##########
# Select a docker container to start and attach to
da() {
  local cid
  cid=$(docker ps -a | sed 1d | fzf -1 -q "$1" | awk '{print $1}')

  [ -n "$cid" ] && docker start "$cid" && docker attach "$cid"
}

# Select a running docker container to stop
ds() {
  local cid
  cid=$(docker ps | sed 1d | fzf -q "$1" | awk '{print $1}')

  [ -n "$cid" ] && docker stop "$cid"
}

# Select a docker container to remove
drm() {
  local cid
  cid=$(docker ps -a | sed 1d | fzf -q "$1" | awk '{print $1}')

  [ -n "$cid" ] && docker rm "$cid"
}

# Same as above, but allows multi selection:
#drm() {
#  docker ps -a | sed 1d | fzf -q "$1" --no-sort -m --tac | awk '{ print $1 }' | xargs -r docker rm
#}

# Select a docker image or images to remove
drmi() {
  docker images | sed 1d | fzf -q "$1" --no-sort -m --tac | awk '{ print $3 }' | xargs -r docker rmi
}


##############
# List files #
##############
# Search and run from list of aliases/functions
falias() {
    CMD=$(
        (
            alias
            declare -F | cut -d ' ' -f3
        ) | fzf | cut -d '=' -f1
    )

    eval $CMD
}

# Search and run from list of functions from scripts.zsh file
fsh() {
    # Source the scripts.zsh file to ensure functions are available
    source ~/.config/zsh/scripts.zsh

    # Extract function names from the scripts.zsh file, excluding those with 2 or fewer characters
    CMD=$(
        grep -oP '^\s*\K\w+(?=\s*\(\))' ~/.config/zsh/scripts.zsh | awk 'length($0) > 2' | fzf
    )

    # Insert the selected function name into the shell
    if [ -n "$CMD" ]; then
        # Use `print -z` to insert the command into the shell buffer
        print -z "$CMD"
    else
        echo "No function selected."
    fi
}

# List cheatsheets and edit
fchtce() {
    file=$(cheat -l -t tools | tail -n +2 | cut -d' ' -f1 | sort | uniq | fzf --preview 'command bat --style=snip --language=help --color=always ~/.config/cheat/tools/{}') || return
	[ -n "$file" ] && command nvim ~/.config/cheat/tools/"$file"
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

  if [ ! "$#" -gt 0 ]; then
    echo "Usage: frgc <search-term>"
    return 1
  fi

  selected_file=$(rg --files-with-matches --no-messages "$1" \
    | fzf --preview "highlight -O ansi -l {} 2> /dev/null \
    | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' \
    || rg --ignore-case --pretty --context 10 '$1' {}")

  if [[ -n "$selected_file" ]]; then
    sed -e 's/^\* .*$/\x1b[94m&\x1b[0m/' -e 's/^\*\*.*$/\x1b[96m&\x1b[0m/' -e 's/=\([^=]*\)=/\o033[1;32m\1\o033[0m/g; s/^\( \{0,6\}\)-/•/g' -e '/^\(:PROPERTIES:\|:ID:\|:END:\|#\+date:\)/d' "$selected_file" | command bat --language=org --style=snip --color=always
  fi

  popd &> /dev/null
}

# List cheatsheets in specific directory based on content and cat the matching line
frgc() {
  pushd ~/.config/cheat/desc/ &> /dev/null

  if [ ! "$#" -gt 0 ]; then
    echo "Usage: frgc <search-term>"
    return 1
  fi

  search_term=$1
  selected_file=$(rg --files-with-matches --no-messages "$search_term" . \
    | sed 's|^\./||' \
    | fzf --preview "highlight -O ansi -l {} 2> /dev/null \
    | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$search_term' \
    || rg --ignore-case --pretty --context 10 '$search_term' {}")

  if [[ -n "$selected_file" ]]; then
    cheat "$selected_file" | rg --ignore-case --pretty "$search_term" | bat --pager less --style=snip --color=always --language=help
  fi

  popd &> /dev/null
}

# List cheatsheets in specific directory and cat with preview
fchtt() {
  file=$(cheat -l -t desc | tail -n +2 | cut -d' ' -f1 | sort | uniq | fzf --preview 'command bat --style=snip --language=help --pager less --color=always ~/.config/cheat/desc/{}') || return
	[ -n "$file" ] && command cheat "$file" | bat --pager less --style=snip --color=always --language=help
}

# List org notes based on content and edit
frgoe() {
  pushd ~/documents/org/roam/ &> /dev/null

  if [ ! "$#" -gt 0 ]; then
    echo "Usage: frgc <search-term>"
    return 1
  fi

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
  file=$(cheat -l -t tools | tail -n +2 | cut -d' ' -f1 | sort | uniq | fzf --preview 'command bat --style=snip --language=help --pager less --color=always ~/.config/cheat/tools/{}') || return
	[ -n "$file" ] && command cheat "$file" | bat --pager less --style=snip --color=always --language=help
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

# List wallpapers directory and change script to use selected one
fwal() {
  result=$(find ~/pictures/wallpapers/* -type d -prune -exec basename {} ';' | sort | uniq | fzf)

  if [ -n "$result" ]; then
    dir_name="$result"
    script_path="$HOME/.config/hypr/scripts/wallpaper"
    full_dir_path="$HOME/pictures/wallpapers/$dir_name"

    if [ -f "$script_path" ]; then
      sed -i "s#^DIR=\".*\"#DIR=\"$full_dir_path\"#g" "$script_path"
      echo "Wallpaper script updated to use directory: $dir_name"
    else
      echo "Wallpaper script not found: $script_path"
    fi
  else
    echo "No directory selected."
  fi
}

# List workspace git repos
fwork() {
    result=$(find ~/desktop/workspace/* -type d -prune -exec basename {} ';' | sort | uniq | nl | fzf | cut -f 2)
    [ -n "$result" ] && cd ~/desktop/workspace/$result ; y
}

# List connected external devices
fdev() {
    result=$(find /run/media/$USER/* -type d -prune -exec basename {} ';' | sort | uniq | nl | fzf | cut -f 2)
    [ -n "$result" ] && cd ~/run/media/$USER/$result ; lsd -l --hyperlink=auto
}

# List projects
fproj() {
    result=$(find ~/desktop/projects/* -type d -prune -exec basename {} ';' | sort | uniq | nl | fzf | cut -f 2)
    [ -n "$result" ] && cd ~/desktop/projects/$result ; y
}

# List current findings reports
frep() {
    result=$(find ~/documents/org/reports/ -type f -name "*.org" -printf "%P\n" | sort | uniq | fzf --preview "sed -e 's/^\* .*$/\x1b[94m&\x1b[0m/' -e 's/^\*\*.*$/\x1b[96m&\x1b[0m/' -e 's/=\([^=]*\)=/\o033[1;32m\1\o033[0m/g; s/^\( \{0,6\}\)-/•/g' -e '/^\(:PROPERTIES:\|:ID:\|:END:\|#\+date:\)/d' ~/documents/org/reports/{} | command bat --language=org --style=snip --color=always" --preview-window=right:50%:wrap) || return

    [ -n "$result" ] && eval "$EDITOR" ~/documents/org/reports/"$result"
}

# List pdfs
fpdf() {
    file=$(find ~/documents/pdfs/* -type f -name '*.pdf' -prune -exec basename {} ';' | sort | uniq | nl | fzf | cut -f 2) || return
    [ -n "$file" ] && zathura "$HOME"/documents/pdfs/"$file" &
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

  if [ ! "$#" -gt 0 ]; then
    echo "Usage: frgc <search-term>"
    return 1
  fi

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

  if [ ! "$#" -gt 0 ]; then
    echo "Usage: frgc <search-term>"
    return 1
  fi

  if [ ! "$#" -gt 0 ]; then return 1; fi
  local file
  file="$(rg --hidden -i --max-count=1 --ignore-case --files-with-matches --no-messages "$*" \
      | fzf-tmux -p +m --preview="rg --hidden -i --ignore-case --pretty --context 10 '"$*"' {}")" \
      && print -z "./$file" || return 1;
}
