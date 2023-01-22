#!/usr/bin/env zsh

# ls to lsd
alias l='lsd --hyperlink=auto'
alias ls='lsd -l --hyperlink=auto'
alias la='lsd -lA --hyperlink=auto'
alias lt='lsd --tree --hyperlink=auto'
alias lx='lsd -lXBh --hyperlink=auto'                # sort by extension
alias lk='lsd -lSrh --hyperlink=auto'                # sort by size
alias lc='lsd -lcrh --hyperlink=auto'                # sort by change time
alias lu='lsd -lurh --hyperlink=auto'                # sort by access time
alias lm='lsd -alh |more --hyperlink=auto'           # pipe through 'more'
alias lf="lsd -l | egrep -v '^d' --hyperlink=auto"   # files only
alias ldir="lsd -l | egrep '^d' --hyperlink=auto"    # directories only

# kitty icat
alias icat='kitty +kitten icat'

# kitty diff
alias diff="kitty +kitten diff"
alias gdiff="git difftool --no-symlinks --dir-diff"

# kitty hyperlinked grep
alias hg="kitty +kitten hyperlinked_grep"

# xcp instead of cp
alias cp='xcp'

# Alias's to modified commands
alias mkdir='mkdir -p'
alias ping='ping -c 5'        
alias less='less -R'
alias svi='sudo vi'
alias train='sl | lolcat'
alias devil='fortune | cowsay -f eyes | lolcat'

# python
alias pyserver='python3 -m http.server'

#continue download
alias wget="wget -c"

# alias to show the date
alias da='date "+%Y-%m-%d %A %T %Z"'

# grub update
alias update-grub="sudo grub-mkconfig -o /boot/grub/grub.cfg"

#add new fonts
alias update-fc='sudo fc-cache -fv'

#hardware info --short
alias hw="hwinfo --short"

#check vulnerabilities microcode
alias microcode='grep . /sys/devices/system/cpu/vulnerabilities/*'

#Recent Installed Packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"
alias riplong="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -3000 | nl"

#get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

#gpg
#verify signature for isos
alias gpg-check="gpg2 --keyserver-options auto-key-retrieve --verify"
alias fix-gpg-check="gpg2 --keyserver-options auto-key-retrieve --verify"
# receive the key of a developer
alias gpg-retrieve="gpg2 --keyserver-options auto-key-retrieve --receive-keys"
alias fix-gpg-retrieve="gpg2 --keyserver-options auto-key-retrieve --receive-keys"
alias fix-keyserver="[ -d ~/.gnupg ] || mkdir ~/.gnupg ; cp /etc/pacman.d/gnupg/gpg. conf ~/.gnupg/ ; echo 'done'"

# hblock (stop tracking with hblock) - use unhblock to stop using hblock
alias unhblock="hblock -S none -D none"

#systeminfo
alias probe="sudo -E hw-probe -all -upload"
alias sysfailed="systemctl list-units --failed"

#btrfs aliases
alias btrfsfs="sudo btrfs filesystem df /"
alias btrfsli="sudo btrfs su li / -t"

# Search running processes
alias p="ps aux | grep "
alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"

#remove
alias rmgitcache="rm -r ~/.cache/git"

# Count all files (recursively) in the current folder
alias countfiles="bash -c \"for t in files links directories; do echo \\\$(find . -  type \\\${t:0:1} | wc -l) \\\$t; done 2> /dev/null\""

# Show current network connections to the server
alias ipview="netstat -anpl | grep :80 | awk {'print \$5'} | cut -d\":\" -f1 | sort  | uniq -c | sort -n | sed -e 's/^ *//' -e 's/ *\$//'"
 
# Show open ports
alias openports='netstat -nape --inet'

# Alias's to show disk space and space used in a folder
alias diskspace="du -S | sort -n -r |more"
alias folders='du -h --max-depth=1'
alias folderssort='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'
alias tree='tree -CAhF --dirsfirst'
alias treed='tree -CAFd'
alias mountedinfo='df -hT'

#snapper aliases
alias snapcroot="sudo snapper -c root create-config /"
alias snapchome="sudo snapper -c home create-config /home"
alias snapli="sudo snapper list"
alias snapcr="sudo snapper -c root create"
alias snapch="sudo snapper -c home create"

# Show all logs in /var/log
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -  f1 | sed -e's/:\$//g' | grep -v '[0-9]\$' | xargs tail -f"

# usefull
alias cats='highlight -O ansi --force'
alias cat='bat --paging=never -p --theme OneHalfDark'
alias ..="cd ../"
alias ...="cd ../../"
alias ....="cd ../../../"

# other
alias tks='tmux kill-server'                               # tmux
alias wget=wget --hsts-file="$XDG_DATA_HOME/wget-hsts"     # wget

# yt-dlp
alias yta-aac="yt-dlp --extract-audio --audio-format aac "
alias yta-best="yt-dlp --extract-audio --audio-format best "
alias yta-flac="yt-dlp --extract-audio --audio-format flac "
alias yta-mp3="yt-dlp --extract-audio --audio-format mp3 "
alias ytv-best="yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+          bestaudio' --merge-output-format mp4 "
alias yt3-mp3="yt-dlp --extract-audio --audio-format mp3 " 

# git
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gitu='git add . && git commit && git push'

# pacman and yay
alias pacsyu='sudo pacman -Syu'                  # update only standard pkgs
alias pacsyyu='sudo pacman -Syyu'                # Refresh pkglist & update standard pkgs
alias yaysua='yay -Sua --noconfirm'              # update only AUR pkgs (yay)
alias yaysyu='yay -Syu --noconfirm'              # update standard pkgs and AUR pkgs (yay)
alias yaysc='yay -Sc'                          # remove orphaned packages

# colorize grep output
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
#search content with ripgrep
alias rg="rg --sort path"

# systemd
alias gcm="git checkout master"
alias gcs="git checkout stable"

# adding flags
alias df='df -h'     # human-readable sizes
alias free='free -m' # show sizes in MB
alias lynx='lynx -cfg=~/.lynx/lynx.cfg -lss=~/.lynx/lynx.lss -vikeys'
alias ncmpcpp='ncmpcpp ncmpcpp_directory=$HOME/.config/ncmpcpp/'
alias vim='nvim'

# ps
alias psa="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias psmem='ps auxf | sort -nr -k 4'
alias pscpu='ps auxf | sort -nr -k 3'

# Zsh Directory Stack
alias d='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index
