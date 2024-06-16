#!/usr/bin/env zsh

################################################################################################
# File management                                                                              #
################################################################################################
# ls
alias l='lsd --hyperlink=auto'
alias ls='lsd -l --hyperlink=auto'
alias la='lsd -lA --hyperlink=auto'
alias lta='lsd --tree --hyperlink=auto'
alias lt='lsd --tree --depth 2 --hyperlink=auto'
alias lt3='lsd --tree --depth 3 --hyperlink=auto'
alias lx='lsd -lXh --hyperlink=auto'                 # Sort by extension
alias lk='lsd -lSrh --hyperlink=auto'                # Sort by size
alias lc='lsd -ltrh --hyperlink=auto'                # Sort by date
#alias lf='lsd -l --hyperlink=auto| grep -v '^d''     # Files only
#alias ld='lsd -l --hyperlink=auto| grep '^d''        # Directories only
alias l.='lsd -A $* | rg "^\."'                    # List hidden files
alias watch-lt='watch lsd --tree --hyperlink=auto'
alias tree='tree -CAhF --dirsfirst'
alias treed='tree -CAFd'

# Count all files recursively in the current folder
alias cf="bash -c \"for t in files links directories; do echo \\\$(find . -  type \\\${t:0:1} | wc -l) \\\$t; done 2> /dev/null\""

# ls with ignore
alias li='lsd --hyperlink=auto --ignore-glob'
alias lsi='lsd -l --hyperlink=auto --ignore-glob'
alias lai='lsd -lA --hyperlink=auto --ignore-glob'
alias lti='lsd --tree --hyperlink=auto --ignore-glob'

# cp
alias cp='xcp'
alias cpi='xcp --exclude'

# rm
alias rm='rm -v'
#rmi is in scripts.zsh
alias trash='trash -rfv'

# mv
alias mv='mv -v'
#mvi is in scripts.zsh

# mkdir
alias mkdir="mkdir -p"

# cat
alias bat='bat --color=always --style header,grid,changes'
alias catl='bat --color=always --paging=never -l log'
alias icat='kitty +kitten icat'
alias cats='highlight -O ansi --force'

# curl
alias xhd='xh --download'
alias wget='wget -c --hsts-file="$XDG_DATA_HOME/wget-hsts"'

# tail
alias tailf="tail -f"

# head
alias headn="head -n"

# dig
alias digs='dig +short'

# sort
alias sip='sort -n -u -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4'

# truncate
alias truncate="truncate -s 0"

# grep
alias rg='rg -i'
alias rgv='rg -v -i'
alias rgf='rg -l -i'
alias rgo='rg -i -l | xargs $EDITOR'
alias rga='rg --hidden -i'
alias rgo='rg -o -i'
alias rgc='rg -c -i'       # count line containing specific string
alias rgs='rg -i --sort'   # Possible sort values: path/modified/accessed/created
# Colorize grep output
#alias grep='ugrep --color=auto'
#alias fgrep='ugrep -F --color=auto'
#alias egrep='ugrep -E --color=auto'
#alias ip='ip --color=auto'   # Already set somewhere

# Find
alias fd='fdfind'
alias fdf='fd --ignore-case --hidden --type f'
alias fdd="fd --ignore-case --hidden --type d"
alias fdex="fd --ignore-case --hidden --exclude"
alias fdl="fd --ignore-case --hidden --list-details"
alias fds='fd --ignore-case --hidden --type f --size'
alias fde='fd --ignore-case --hidden --type f --extension'
alias fdr='fd --ignore-case --hidden --type f --exec rg -l'
alias fdc='fd --ignore-case --hidden --type f --exec bat --color=always {}'
alias fdb="fd --ignore-case --hidden --type f --size +100M --exec lsd -l --hyperlink=auto {} ; ."
alias fdsh="fd . -e py -e sh ~/desktop/workspace/dotfiles/.config/.install/ | xargs wc -l"


################################################################################################
# Change directory                                                                             #
################################################################################################
# HOME dirs
alias r='cd $HOME ; clear'
alias dw='cd "$HOME/downloads" ; clear ; lsd -l --hyperlink=auto'
alias dt='cd "$HOME/desktop" ; clear ; lsd -l --hyperlink=auto'
alias pc='cd "$HOME/pictures" ; clear ; lsd -l --hyperlink=auto'
alias vd='cd "$HOME/videos" ; clear ; lsd -l --hyperlink=auto'
alias dc='cd "$HOME/documents" ; clear ; lsd -l --hyperlink=auto'
alias org='cd "$HOME/documents/org/roam" ; clear ; lsd -l --hyperlink=auto'
alias sv='cd "$HOME/desktop/server" ; clear ; lsd -l --hyperlink=auto'
alias scr='cd "$HOME/pictures/screenshots" ; clear ; fimg'
alias pj='cd "$HOME/desktop/projects" ; clear ; lsd -l --hyperlink=auto'
alias ws='cd "$HOME/desktop/workspace" ; clear ; lsd -l --hyperlink=auto'
# Note files
alias general='emacsclient -nw "$HOME/documents/org/roam/red-team/general.org"'
alias ipt='emacsclient -nw "$HOME/documents/org/roam/red-team/ipt.org"'
alias ept='emacsclient -nw "$HOME/documents/org/roam/red-team/ept.org"'
alias se='emacsclient -nw "$HOME/documents/org/roam/red-team/se.org"'
alias physical='emacsclient -nw "$HOME/documents/org/roam/red-team/physical.org"'
alias wir='emacsclient -nw "$HOME/documents/org/roam/red-team/wir.org"'

# Enhancd: cd <dir>, cd, cd -, ..
alias ..="cd .."
alias ...='cd ../..'
alias ....='cd ../../..'

# Alias for copying the current working directory to clipboard
alias ccp='print -n "${PWD:a}" | wl-copy || return 1; echo ${(%):-"%B${PWD:a}%b copied to clipboard."}'


##############################################################################################################
# System management                                                                                          #
##############################################################################################################
# Apt-get
alias pacsyu="sudo apt-get update && sudo apt-get upgrade"
alias kali-version="lsb_release -a"                  # check system version
alias kali-upgrade="sudo apt update && sudo apt full-upgrade -y"    # Upgrade to the latest kali version
alias pacs="sudo apt update && sudo apt install"
alias pacr="sudo apt update && sudo apt purge"          # Remove with its configuration files
alias cleanup="sudo apt update && sudo apt autoremove"
alias aptcache="sudo du -sh /var/cache/apt/archives"
alias aptcache-clean="sudo apt clean"
alias pacf="sudo apt-cache search"
alias rip-apt="sudo apt list --installed"
alias rip-snap="snap list"
alias apt-history='grep " install " /var/log/apt/history.log'

# Systemd
alias sdlistall="sudo systemctl list-unit-files --type=service"
alias sdlisten="sudo systemctl list-unit-files --type=service --state=enabled"
alias sdlistds="sudo systemctl list-unit-files --type=service --state=disabled"
alias sdlista="sudo systemctl list-units --type=service --state=active"
alias sdstatus="sudo systemctl status"
alias sdstart="sudo systemctl start"
alias sdstop="sudo systemctl stop"
alias sden="sudo systemctl enable --now"
alias sdds="sudo systemctl disable"

# Recent installed packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"
alias riplong="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -3000 | nl"
alias big="expac -H M '%m\t%n' | sort -h | nl"

# Systeminfo
alias probe="sudo -E hw-probe -all -upload"
alias sysfailed="systemctl list-units --failed"
alias hw="hwinfo --short"
alias go-update="go get -u all"

# ps
alias psa="ps auxf"
alias psrg="ps aux | grep -v grep | grep -i -e VSZ -e"
alias psmem="ps auxf | sort -nr -k 4"
alias psmem10="ps auxf | sort -nr -k 4 | head -10"
alias pscpu="ps auxf | sort -nr -k 3"
alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"

# Show all logs in /var/log
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -  f1 | sed -e's/:\$//g' | grep -v '[0-9]\$' | xargs tail -f"

# File system
alias fs-mounted="sudo mount | column -t"
alias fs-usage="df -mTh --total"
alias fs-last3="sudo find /etc -mtime -3"
alias fs-large="sudo find / -type f -size +1G"
alias fs-mem-top10="sudo ps aux | sort -rk 4,4 | head -n 10 | awk '{print \$4,\$11}' "
alias fs-disk-top10="sudo du -sk ./* | sort -r -n | head -10"
alias fs-mounted=""
alias free="free -m"
alias mem-free="free -th"

# disk usage
alias du='dust'
alias ncdu="ncdu --color dark"
alias duf="duf --hide special -hide-mp /run/user/1000/psd/twilight-firefox-nlmda6r7.default,/run/user/1000/psd/twilight-firefox-pjxpviu5.default-esr"
alias biggest="du -h --max-depth=1 | sort -h"
alias diskspace="du -S | sort -n -r |less -R"
alias folders='du -h --max-depth=1'
alias folderssort='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'


#################################################################################################
# Networking                                                                                    #
#################################################################################################
alias net-watch="sudo watch -n 0.3 'netstat -pantlu4 | grep \"ESTABLISHED\|LISTEN\"' "
alias net-open4="sudo netstat -pantlu4"
alias net-open6="sudo netstat -pantlu6"
alias net-routes="netstat -r --numeric-hosts"
alias net-ss="sudo ss -plaunt4"
alias net-lsof="sudo lsof -P -i -n "
alias net-pubip="curl -s \"https://icanhazip.com\" "
alias net-adapter="inxi -Na"
alias net-lspci="lspci -nn | grep -i net"
alias net-ps="lsof -i -n | awk '/ESTABLISHED/ {print \$1}' | sort -u"
#alias net-psn="ss -tp | grep -v Recv-Q | sed -e 's/.*users:((\"//' -e 's/\".*$//' | sort | uniq"
#alias w='cd "$HOME/desktop/server" ; echo "$(hip) in $PWD" ; sudo python3 -m http.server 80'
#alias w2='cd "$HOME/desktop/server" ; echo "$(hip) in $PWD" ; sudo python3 -m http.server 8000'
#alias w3='ngrok http 4444'
#alias m='service postgresql start ; msfdb init ; msfconsole'

# Show current network connections to the server
alias nethog='sudo nethogs'
alias ipview="netstat -anpl | grep :80 | awk {'print \$5'} | cut -d\":\" -f1 | sort  | uniq -c | sort -n | sed -e 's/^ *//' -e 's/ *\$//'"
alias ip='ip -color'
alias wlo1='echo $(ifconfig wlo1 | rg "inet " | cut -b 9- | cut  -d" " -f2)'
alias tun0='echo $(ifconfig tun0 | rg "inet " | cut -b 9- | cut  -d" " -f2)'

# Proton vpn (v4 version doens't support cli)
#alias net-pvpn-connect-tcp="sudo protonvpn c -f"
#alias net-pvpn-connect-udp="sudo protonvpn c -f -p udp"
#alias net-pvpn-status="sudo protonvpn status"
#alias net-disconnect="sudo protonvpn disconnect"

# Show open ports
alias openports='netstat -nape --inet'
alias port="netstat -tulpn | rg"

# Updates
alias gu='git add . && git commit -m "update" && git push'
alias guorg='\cd ~/documents/org/ && git add . && git commit -m "update" && git push && \cd -'
alias gucht='\cd ~/.config/cheat/ && git add . && git commit -m "update" && git push && \cd -'

# Udiskie-umount
alias ubackup='udiskie-umount $MEDIA/BACKUP'
alias umedia='udiskie-umount $MEDIA/*'

# Git
alias gconfig="git config --list"
alias gd='git diff'
alias gdif="git diff --no-index"          # Diff two files even if not in git repo! Can add -w (don't diff whitespaces)
alias gshow='git show'   # gshow <commit_id> - show diff from commit
alias gdiff="git difftool --no-symlinks --dir-diff"
alias gs='git status'
alias gss='git status -s'
alias grs='git restore --staged'  #grs <file> - remove from staging area
alias gr='git restore'   #gr <file> - restore accidentally removed file
alias greset='git reset' #greset <commit_id> - reset to change from commit
alias greseth='git reset --hard' #greseth <commit_id> - reset change in cwd
alias gl='git log --pretty=oneline'
alias glog='git log --graph --abbrev-commit --oneline --decorate'
alias gj="git-jump"                      # Open in vim quickfix list files of interest (git diff, merged...)
#alias gc="git clone --depth 1"     # have 'gcl' function
alias gci="cloneit"
alias rmgitcache="rm -r ~/.cache/git"
alias gcm="git checkout master"
alias gcs="git checkout stable"
alias gpraise='git blame'
alias grb='git branch -r'
alias gb='git branch'
alias gco='git checkout'


##############################################################################################################
# Aliases to modified commands                                                                               #
##############################################################################################################
alias s="kitty +kitten ssh"
alias ce='cheat --edit'
alias ping="prettyping -c 3"
#alias pg='prettyping -c 3 8.8.8.8'
#alias less="less -R"   # have function as 'less'
alias kill='sudo killall -q'
alias wire-desktop='wire-desktop --password-store="gnome-libsecret"'
alias fkill='~/.config/zsh/fzf-scripts/fkill'
alias fetch='clear && neofetch && fortune ~/.config/fortune/quotes'
alias nfetch='clear && neofetch --kitty ~/pictures/bateman.png && fortune ~/.config/fortune/quotes'
alias devil="fortune ~/.config/fortune/quotes | cowsay -f eyes | lolcat"
alias matrix="cmatrix -a"
alias clock="tty-clock -c -C 4 -r -s -f \"%A, %B, %d\""
alias asciiquarium="asciiquarium --transparent"
alias h2t="html2text -style pretty"
alias x2h="xsltproc -o result.html"
alias e="emacsclient -nw"
#alias docker="sudo docker"
alias norg="gron --ungron"
alias ungron="gron --ungron"
alias open='xdg-open'
alias da='date "+%Y-%m-%d %A %T %Z"'
alias update-fc='sudo fc-cache -fv'
alias jctl="journalctl -p 3 -xb"
alias jctle="journalctl --user -xeu"    # show error messages, specify a unit
alias notif="cat /tmp/notify.log"
alias okitty='kitty -o allow_remote_control=yes --single-instance --listen-on unix:@mykitty'
alias grubup="sudo update-grub"
#alias ginxi="garuda-inxi"
#alias gup="garuda-update"
alias lsall="lspci"
alias mic-record="pw-record ./recording.mp3"
alias gparted="xhost +SI:localuser:root && gparted"    # Optionally try running ocmmand: "xhost +localhost" and then "sudo gparted"
alias fluxion='xhost +SI:localuser:root && sudo fluxion'
alias nmap="grc nmap"
alias empire="sudo powershell-empire client"
alias start-neo4j-db='sudo neo4j console'
alias hashid='hashid -m'
#alias amassc='amass enum -config ~/.config/amass/config.ini -d $1'

# Mpv
alias mpk='mpv --no-input-builtin-bindings --profile=sw-fast --vo=kitty'
alias mpvadd='mpv --no-input-builtin-bindings --ytdl'
alias mpvpl='mpv --no-input-builtin-bindings "$(yt-dlp -g --flat-playlist "$1")"'
alias mpa='mpv --no-input-builtin-bindings --no-video'
alias mpapl='mpv --no-input-builtin-bindings --no-video "$(yt-dlp -g -x --audio-format mp3 --flat-playlist "$1")"'
alias ytfzf-random='ytfzf -f -A -r -n 10'

# Wi-fi
alias wifi-on='nmcli r wifi on'
alias wifi-off='nmcli r wifi off'

# Check CPU mitigations vulnerabilities in microcode
alias microcode='grep . /sys/devices/system/cpu/vulnerabilities/*'

# Using AMD P-State EPP scheduler
alias pstate='cat /sys/devices/system/cpu/amd_pstate/status'   # Check if the p-state driver is active
alias powersave='sudo auto-cpufreq --force=powersave && sudo cpupower --cpu all frequency-set -g powersave'
alias performance='sudo auto-cpufreq --force=performance && sudo cpupower --cpu all frequency-set -g performance'
alias cpu-reset='sudo auto-cpufreq --force=reset'
# Omen laptop settings
#alias omen-fix='~/.config/.local/bin/omen-fix-startup'    # RUN AS ROOT/systemd service
alias omen-status='sudo systemctl status omen-performance-fix.service'
alias cpu-temp='sensors zenpower-pci-00c3'     # Check CPU thermals
alias watch-fans='watch sensors hp-isa-0000'              # Check Cooling fan speed
#other scripts - run as root: fan-boost-on fan-boost-off omen-keyboard

# Hblock (stop tracking with hblock) - use unhblock to stop using hblock
alias unhblock="hblock -S none -D none"
