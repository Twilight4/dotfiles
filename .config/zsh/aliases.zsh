#!/usr/bin/env zsh

# ls to lsd
alias l='lsd --hyperlink=auto'
alias ls='lsd -l --hyperlink=auto'
alias la='lsd -lA --hyperlink=auto'
alias lt='lsd --tree --hyperlink=auto'
alias lx='lsd -lXh --hyperlink=auto'                 # Sort by extension
alias lk='lsd -lSrh --hyperlink=auto'                # Sort by size
alias lc='lsd -ltrh --hyperlink=auto'                # Sort by date
#alias lf='lsd -l --hyperlink=auto| grep -v '^d''     # Files only
#alias ld='lsd -l --hyperlink=auto| grep '^d''        # Directories only
alias l.='lsd -A $* | grep "^\."'                    # List hidden files

# HOME dirs
alias dw='cd "$HOME/downloads" ; clear ; lsd -l --hyperlink=auto'
alias pc='cd "$HOME/pictures" ; clear ; lsd -l --hyperlink=auto'
alias vd='cd "$HOME/videos" ; clear ; lsd -l --hyperlink=auto'
alias dc='cd "$HOME/documents" ; clear ; lsd -l --hyperlink=auto'
alias org='cd "$HOME/documents/org" ; clear ; lsd -l --hyperlink=auto'
alias sv='cd "$HOME/desktop/server" ; clear ; lsd -l --hyperlink=auto'
alias sc='cd "$HOME/pictures/screenshots" ; clear ; fimg'

# Work dirs
alias pj='cd "$HOME/desktop/projects" ; clear'
alias lpj='lsd --tree --hyperlink=auto ~/desktop/projects'
alias ws='cd "$HOME/desktop/workspace" ; clear'

# Enhancd: cd, cd-, cd <jump_to_dir>, .., .
alias cd-="cd -"
alias .="cd ."
alias ..="cd .."
alias ...='cd ../..'
alias ....='cd ../../..'

# Alias for copying the current working directory to clipboard
alias ccp='print -n "${PWD:a}" | wl-copy || return 1; echo ${(%):-"%B${PWD:a}%b copied to clipboard."}'

# Common usage
alias r='cd $HOME ; clear'
alias mv='mv -v'
alias rm='rm -v'
alias w='cd "$HOME/desktop/server" ; echo "$(hip) in $PWD" ; sudo python3 -m http.server 80'
alias w2='cd "$HOME/desktop/server" ; echo "$(hip) in $PWD" ; sudo python3 -m http.server 8000'
alias w3='ngrok http 4444'
alias s="kitty +kitten ssh"
alias m='service postgresql start ; msfdb init ; msfconsole'
alias ce='cheat --edit'
alias ai='tgpt'
alias watch-lt='watch lsd --tree --hyperlink=auto'

# Blackarch repo packages
alias blackall="sudo pacman -Sgg | grep blackarch | cut -d' ' -f2 | sort -u"  # List all available tools
alias blackcat="sudo pacman -Sg | grep blackarch"                             # See the blackarch categories

# Aliases to modified commands
alias mkdir="mkdir -p"
alias ping="prettyping -c 3"
alias pg='prettyping -c 3 8.8.8.8'
#alias less="less -R"   # have function as 'less'
alias kill='killall -q'
alias tr="trash"
alias fetch='clear && neofetch && fortune ~/.config/fortune/quotes'
alias nfetch='clear && neofetch --kitty ~/pictures/bateman.png && fortune ~/.config/fortune/quotes'
alias devil="fortune ~/.config/fortune/quotes | cowsay -f eyes | lolcat"
alias matrix="cmatrix -a"
alias clock="tty-clock -c -C 4 -r -s -f \"%A, %B, %d\""
alias asciiquarium="asciiquarium --transparent"
alias h2t="html2text -style pretty"
alias x2h="xsltproc -o result.html"
alias e="emacsclient -nw"
alias docker="sudo docker"
alias biggest="du -h --max-depth=1 | sort -h"
alias norg="gron --ungron"
alias ungron="gron --ungron"
alias open='xdg-open'
alias da='date "+%Y-%m-%d %A %T %Z"'
alias update-fc='sudo fc-cache -fv'
alias jctl="journalctl -p 3 -xb"
alias jctle="journalctl --user -xeu"    # show error messages, specify a unit
alias notif="cat /tmp/notify.log"
alias sip='sort -n -u -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4'
alias wget='wget -c --hsts-file="$XDG_DATA_HOME/wget-hsts"'
alias cats='highlight -O ansi --force'
alias okitty='kitty -o allow_remote_control=yes --single-instance --listen-on unix:@mykitty'
alias icat='kitty +kitten icat'
alias news="newsboat"
alias tailf="tail -f"
alias truncate="truncate -s 0"
alias grubup="sudo update-grub"
alias ginxi="garuda-inxi"
alias gup="garuda-update"
alias lsall="lspci"

# Rust replacements
alias cp='xcp -v'
alias http='xh'                # Curl replacement
alias httpd='http --download'  # Uses xh alias first if installed
#alias bat='bat --color=always --paging=never --theme OneHalfDark'
alias bat='bat --style header --style snip --style changes --style header'
alias catl='bat --color=always --paging=never -l log'
alias dig='dog'
alias digs='dig +short'        # Uses dog alias first if installed
alias du='dust'
alias ncdu="ncdu --color dark"

# Grep - rg
alias rg='rg -i'
alias rgv='rg -v -i'
alias rgf='rg -l -i'
alias rgo='rg -i -l | xargs $EDITOR'
alias rga='rg --hidden -i'
alias rgo='rg -o -i'
alias rgc='rg -c -i'
alias rgs='rg -i --sort'   # Possible sort values: path/modified/accessed/created

# Find - fd
alias fdf='fd --ignore-case --hidden --type f'
#alias fdd="fd --ignore-case --hidden --type d"
alias fdex="fd --ignore-case --hidden --exclude"
alias fdl="fd --ignore-case --hidden --list-details"
alias fds='fd --ignore-case --hidden --type f --size'
alias fde='fd --ignore-case --hidden --type f --extension'
alias fdr='fd --ignore-case --hidden --type f --exec rg -l'
alias fdc='fd --ignore-case --hidden --type f --exec bat --color=always {}'
alias fdb="fd --ignore-case --hidden --type f --size +100M --exec lsd -l --hyperlink=auto {} ; ."
alias fdsh="fd . -e py -e sh ~/desktop/workspace/dotfiles/.config/.install/ | xargs wc -l"

# Mpv
alias mpk='mpv --no-input-builtin-bindings --profile=sw-fast --vo=kitty'
alias mpvadd='mpv --no-input-builtin-bindings --ytdl'
alias mpvpl='mpv --no-input-builtin-bindings "$(yt-dlp -g --flat-playlist "$1")"'
alias mpa='mpv --no-input-builtin-bindings --no-video'
alias mpapl='mpv --no-input-builtin-bindings --no-video "$(yt-dlp -g -x --audio-format mp3 --flat-playlist "$1")"'

# Trans
alias tre='trans en:pl'
alias trp='trans pl:en'

# Check CPU mitigations vulnerabilities in microcode
alias microcode='grep . /sys/devices/system/cpu/vulnerabilities/*'

# Using AMD P-State EPP scheduler
alias pstate='cat /sys/devices/system/cpu/amd_pstate/status'   # Check if the p-state driver is active
alias powersave='sudo auto-cpufreq --force=powersave && sudo cpupower frequency-set -g powersave'
alias performance='sudo auto-cpufreq --force=performance && sudo cpupower frequency-set -g performance'
alias cpu-reset='sudo auto-cpufreq --force=reset'
# Omen laptop settings
#alias omen-fix='~/.config/.local/bin/omen-fix-startup'    # RUN AS ROOT/systemd service
alias omen-status='sudo systemctl status omen-performance-fix.service'
alias cpu-temp='sensors zenpower-pci-00c3'     # Check CPU thermals
alias fans='sensors hp-isa-0000'              # Check Cooling fan speed
alias fan-boost-on='echo 0 > /sys/devices/platform/hp-wmi/hwmon/hwmon*/pwm1_enable'
alias fan-boost-off='echo 2 > /sys/devices/platform/hp-wmi/hwmon/hwmon*/pwm1_enable'

# Recent installed packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"
alias riplong="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -3000 | nl"
alias big="expac -H M '%m\t%n' | sort -h | nl"
alias gitpkg="pacman -Q | grep -i '\-git' | wc -l"

# Refreshing mirrorlists
alias rank-mirrors="sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak && sudo reflector --verbose --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist && cat /etc/pacman.d/mirrolist"
alias rank-mirrors-quick="sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup && sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.backup && sudo rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist"

# Gpg - verify signature for isos
alias gpg-check="gpg2 --keyserver-options auto-key-retrieve --verify"
alias fix-gpg-check="gpg2 --keyserver-options auto-key-retrieve --verify"
# Gpg - receive the key
alias gpg-retrieve="gpg2 --keyserver-options auto-key-retrieve --receive-keys"
alias fix-gpg-retrieve="gpg2 --keyserver-options auto-key-retrieve --receive-keys"
alias fix-keyserver="[ -d ~/.gnupg ] || mkdir ~/.gnupg ; cp /etc/pacman.d/gnupg/gpg. conf ~/.gnupg/ ; echo 'done'"

# Hblock (stop tracking with hblock) - use unhblock to stop using hblock
alias unhblock="hblock -S none -D none"

# Systeminfo
alias probe="sudo -E hw-probe -all -upload"
alias sysfailed="systemctl list-units --failed"
alias hw="hwinfo --short"
alias go-update="go get -u all"

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

# Network
alias net-watch="sudo watch -n 0.3 'netstat -pantlu4 | grep \"ESTABLISHED\|LISTEN\"' "
alias net-open4="sudo netstat -pantlu4"
alias net-open6="sudo netstat -pantlu6"
alias net-routes="netstat -r --numeric-hosts"
alias net-ss="sudo ss -plaunt4"
alias net-lsof="sudo lsof -P -i -n "
alias net-pubip="curl -s \"https://icanhazip.com\" "
alias net-pvpn-update="sudo pip3 install protonvpn-cli --upgrade"
alias net-pvpn-status="sudo protonvpn status"
alias net-pvpn-connect-tcp="sudo protonvpn c -f"
alias net-pvpn-connect-udp="sudo protonvpn c -f -p udp"
alias net-disconnect="sudo protonvpn disconnect"

# Udiskie-umount
alias ubackup='udiskie-umount $MEDIA/BACKUP'
alias umedia='udiskie-umount $MEDIA/*'

# Count all files (recursively) in the current folder
alias cf="bash -c \"for t in files links directories; do echo \\\$(find . -  type \\\${t:0:1} | wc -l) \\\$t; done 2> /dev/null\""

# Show current network connections to the server
alias nethog='sudo nethogs'
alias psnet="lsof -i -n | awk '/ESTABLISHED/ {print \$1}' | sort -u"
alias ipview="netstat -anpl | grep :80 | awk {'print \$5'} | cut -d\":\" -f1 | sort  | uniq -c | sort -n | sed -e 's/^ *//' -e 's/ *\$//'"
alias ip='ip -color'
alias wlo1='echo $(ifconfig wlo1 | rg "inet " | cut -b 9- | cut  -d" " -f2)'
alias tun0='echo $(ifconfig tun0 | rg "inet " | cut -b 9- | cut  -d" " -f2)'
 
# Show open ports
alias openports='netstat -nape --inet'
alias port="netstat -tulpn | rg"

# Show disk space and space used in a folder
alias diskspace="du -S | sort -n -r |less -R"
alias folders='du -h --max-depth=1'
alias folderssort='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'
alias tree='tree -CAhF --dirsfirst'
alias treed='tree -CAFd'

# Show all logs in /var/log
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -  f1 | sed -e's/:\$//g' | grep -v '[0-9]\$' | xargs tail -f"

# Git
alias gconfig="git config --list"
alias gd='git diff'
alias dif="git diff --no-index"          # Diff two files even if not in git repo! Can add -w (don't diff whitespaces)
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
alias gu='git add . && git commit -m "update" && git push'
alias rmgitcache="rm -r ~/.cache/git"
alias gcm="git checkout master"
alias gcs="git checkout stable"
alias gpraise='git blame'
alias grb='git branch -r'
alias gb='git branch'
alias gco='git checkout'

# Pacman
alias pacs="sudo pacman -S"                      # Install package faster
alias pacr="sudo pacman -Rns"                    # Remove package faster
alias pacf="sudo pacman -F"                      # Search binary package faster
alias pacu="sudo pacman -U"                      # Install the needed package
alias pacsyu="sudo pacman --noconfirm -Syuu"     # Update only standard pkgs
alias pacsyyu="sudo pacman -Syyu"                # Refresh pkglist & update standard pkgs
alias cleanup="sudo pacman -Rns (pacman -Qtdq)"  # Cleanup orphaned packages

# Pacman issues
alias rmdblock="sudo rm /var/lib/pacman/db.lck"  # Fix “unable to lock database” Error
alias fix-keys="sudo pacman-key --init; sudo pacman-key --populate; sudo pacman-key --lsign cachyos"

# Paru
alias pars="paru -S"                              # Install AUR package faster
alias parr="paru -Rns"                            # Remove package faster
alias parf="paru -F"                              # Search binary package faster
alias parsyu="paru -Syuu --noconfirm"             # Update standard pkgs and AUR pkgs
alias parsyur="paru --noconfirm -Syuu && sleep 5 && reboot"        # Update and reboot
alias parsyus="paru --noconfirm -Syuu && sleep 5 && shutdown now"  # Update and shutdown
alias parhi='paru -Ql'                            # Paru Has Installed - what files where installed in a package
alias parss='paru -Ss'                            # Search
alias parc='paru -Sc'                             # Remove pacman's cache
alias parro='paru -Rns $(pacman -Qtdq)'
alias parls="paru -Qe"

# Revert to an older version of the package
alias pkgver="cd /var/cache/pacman/pkg && lsd -l --hyperlink=auto"     # Go into the pacman cache and find the needed package.
alias paruu="sudo pacman -U package"

# Colorize grep output
alias grep='ugrep --color=auto'
alias fgrep='ugrep -F --color=auto'
alias egrep='ugrep -E --color=auto'

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

# Amass config alias
alias Amass='amass enum -config ~/.config/amass/config.ini -d $1'

# Search running processes
alias psa="ps auxf"
alias psrg="ps aux | grep -v grep | grep -i -e VSZ -e"
alias psmem="ps auxf | sort -nr -k 4"
alias psmem10="ps auxf | sort -nr -k 4 | head -10"
alias pscpu="ps auxf | sort -nr -k 3"
alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"
alias psn="ss -tp | grep -v Recv-Q | sed -e 's/.*users:(("//' -e 's/".*$//' | sort | uniq"

# Zsh Directory Stack
alias d='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index
