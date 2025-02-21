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
alias watch='watch -n 0.5'
alias watch-lt='watch tree'
alias watch-ls='watch ls -alh --hyperlink=auto'
alias tree='tree -CAhF --dirsfirst'
alias treed='tree -CAFd'
# ls with ignore
alias li='lsd --hyperlink=auto --ignore-glob'
alias lsi='lsd -l --hyperlink=auto --ignore-glob'
alias lai='lsd -lA --hyperlink=auto --ignore-glob'
alias lti='lsd --tree --hyperlink=auto --ignore-glob'

# basic
alias mkdir="mkdir -p"
#alias ci='xcp'     # breaks fzf
#alias cie='xcp --exclude'
alias tailf="tail -f"
alias headn="head -n"
alias mv='mv -v'    #mvi is in scripts.zsh
alias rm='rm -v'    #rmi is in scripts.zsh
alias rt='trash -rfv'
alias shred='shred -u'
alias digs='dig +short'
alias sip='sort -n -u -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4'
alias truncate="truncate -s 0"

# Remote browsing aliases
alias mput='mega-put -c'
alias mget='mega-get'
alias mls='mega-ls -lah'
alias mlt='mega-ls --tree'
alias mlta='mega-ls --tree -lah'
alias mcd='mega-cd'
alias mmv='mega-mv'
alias mrm='mega-rm'
alias mcat='mega-cat'
alias mcp='mega-cp'
alias mdf='mega-df -h'
alias mwhoami='mega-whoami -l'
alias mpwd='mega-pwd'
alias mdu='mega-du -h'

# Count all files recursively in the current folder
alias cf="bash -c \"for t in files links directories; do echo \\\$(find . -  type \\\${t:0:1} | wc -l) \\\$t; done 2> /dev/null\""

# cat
alias bat='bat --color=always --style header,grid,changes --paging never'
alias brg='PAGER=less batgrep -i'
alias bman='batman'
alias bwatch='batwatch'
alias catl='bat --color=always --paging=never -l log'
alias icat='kitty +kitten icat'
alias cats='highlight -O ansi --force'

# curl
alias xhd='xh --download'
alias wget='wget -c --hsts-file="$XDG_DATA_HOME/wget-hsts"'
alias curl-pubip="curl -s http://ifconfig.me"
alias curl-ipinfo="curl -s ip-api.com"
alias rickroll="curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash"
alias termbin="nc termbin.com 9999"     # Usage: echo some text | termbin        (To read the text: curl https://termbin.com/<link>)
alias qrencodet="qrencode -t ansi256utf8"

# ripgrep
alias rg='rg -i'
alias rgv='rg -v -i'
alias rgf='rg -l -i'
alias rgo='rg -i -l | xargs $EDITOR'
alias rga='rg --hidden -i'
alias rgo='rg -o -i'
alias rgc='rg -c -i'       # count line containing specific string
alias rgs='rg -i --sort'   # Possible sort values: path/modified/accessed/created
alias rg-emails="grep -oe '[a-zA-Z0-9._]\+@[a-zA-Z]\+\.[a-zA-Z]\+'"  # Find emails
alias rg-ips_only="grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b'"       # Find IPs
alias rg-ips="grep -E '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b'"             # Find lines that contain an IP
# Colorize grep output
alias grep='ugrep --color=auto'
alias fgrep='ugrep -F --color=auto'
alias egrep='ugrep -E --color=auto'
alias ip='ip -color'

# Find
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
alias sc='cd "$HOME/pictures/screenshots" ; clear ; fimg'
alias vd='cd "$HOME/videos" ; clear ; lsd -l --hyperlink=auto'
alias mc='cd "$HOME/music" ; clear ; lsd -l --hyperlink=auto'
alias dc='cd "$HOME/documents" ; clear ; lsd -l --hyperlink=auto'
alias org='cd "$HOME/documents/org" ; clear ; lsd -l --hyperlink=auto'
alias sv='cd "$HOME/desktop/server" ; clear ; lsd -l --hyperlink=auto'
alias pj='cd "$HOME/desktop/projects" ; clear ; lsd -l --hyperlink=auto'
alias ws='cd "$HOME/desktop/workspace" ; clear ; lsd -l --hyperlink=auto'
# Note files
alias ipt='emacsclient -nw "$HOME/documents/org/roam/red-team/ipt.org"'
alias ept='emacsclient -nw "$HOME/documents/org/roam/red-team/ept.org"'
alias se='emacsclient -nw "$HOME/documents/org/roam/red-team/se.org"'

# Enhancd: cd <dir>, cd, cd -, ..
alias ..="cd .."
alias ...='cd ../..'
alias ....='cd ../../..'

# Alias for copying the current working directory to clipboard
alias ccp='print -n "${PWD:a}" | wl-copy || return 1; echo ${(%):-"%B${PWD:a}%b copied to clipboard."}'


##############################################################################################################
# System management                                                                                          #
##############################################################################################################
# Systemd
alias sd-listall="sudo systemctl list-unit-files --type=service"
alias sd-listen="sudo systemctl list-unit-files --type=service --state=enabled"
alias sd-listds="sudo systemctl list-unit-files --type=service --state=disabled"
alias sd-lista="sudo systemctl list-units --type=service --state=active"
alias sd-status="sudo systemctl status"
alias sd-start="sudo systemctl start"
alias sd-stop="sudo systemctl stop"
alias sd-en="sudo systemctl enable --now"
alias sd-ds="sudo systemctl disable"

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
alias ps-a="ps auxf"
alias ps-rg="ps aux | rg -i -e VSZ -e"
alias ps-mem="ps auxf | sort -nr -k 4"
alias ps-mem10="ps auxf | sort -nr -k 4 | head -10"
alias ps-cpu="ps auxf | sort -nr -k 3"
alias ps-topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"

# Show all logs in /var/log
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:\$//g' | grep -v '[0-9]\$' | xargs tail -f"

# File system
alias fs-top10="sudo du -sk ./* | sort -r -n | head -10"
alias fs-mounted="sudo mount | column -t"
alias fs-usage="df -mTh --total"
alias fs-last3="sudo find /etc -mtime -3"
alias fs-large="sudo find / -type f -size +1G"
alias fs-mem-top10="sudo ps aux | sort -rk 4,4 | head -n 10 | awk '{print \$4,\$11}' "
alias fs-disk-top10="sudo du -sk ./* | sort -r -n | head -10"
alias fs-mounted=""
alias free="free -m"
alias mem-free="free -th"
alias mem-top10="sudo ps aux | sort -rk 4,4 | head -n 10 | awk '{print \$4,\$11}'"

# disk usage
alias bdu='dust'
alias ncdu="ncdu --color dark"
alias duf="duf --hide special -hide-mp /run/user/1000/psd/twilight-firefox-nlmda6r7.default,/run/user/1000/psd/twilight-firefox-pjxpviu5.default-esr,/var/tmp,/var/log,/var/cache,/srv,/boot/efi"
alias watch-duf="watch duf --hide special -hide-mp /run/user/1000/psd/twilight-firefox-nlmda6r7.default,/run/user/1000/psd/twilight-firefox-pjxpviu5.default-esr,/var/tmp,/var/log,/var/cache,/srv,/boot/efi"
alias biggest="du -h --max-depth=1 | sort -h"
alias diskspace="du -S | sort -n -r |less -R"
alias folders='du -h --max-depth=1'
alias folderssort='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'


#################################################################################################
# Networking                                                                                    #
#################################################################################################
alias net-watch="sudo watch -n 0.3 'netstat -pantlu4 | grep \"ESTABLISHED\|LISTEN\"'"
alias net-open4="sudo netstat -pantlu4"
alias net-open6="sudo netstat -pantlu6"
alias net-routes="netstat -r --numeric-hosts"
alias net-ss="sudo ss -plaunt4"
alias net-lsof="sudo lsof -P -i -n "
alias net-vnstat="vnstati -L -s -i wlo1 -o ~/vnstat-summary.png && vnstati -L -t -i wlo1 -o ~/vnstat-top.png && vnstati -L -m -i wlo1 -o ~/vnstat-monthly.png && vnstati -L -d -i wlo1 -o ~/vnstat-daily.png && vnstati -L -h -i wlo1 -o ~/vnstat-hourly.png && echo 'Images saved in $HOME.'"
alias net-wlan0="ifconfig wlan0 | grep 'inet ' | awk '{print \$2}'"
alias net-tun0="ifconfig tun0 | grep 'inet ' | awk '{print \$2}'"
alias net-gateway="ip route | grep via | grep wlan0 | cut -d' ' -f3"
alias net-adapter="inxi -Na"
alias net-lspci="lspci -nn | grep -i net"
alias net-ps="lsof -i -n | awk '/ESTABLISHED/ {print \$1}' | sort -u"
#alias net-block-ipi="sudo iptables -A INPUT -s"       # Enter IP to block for a bind shell
#alias net-block-ipo="sudo iptables -A OUTPUT -s"      # Enter IP to block for a reverse shell
#alias net-psn="ss -tp | grep -v Recv-Q | sed -e 's/.*users:((\"//' -e 's/\".*$//' | sort | uniq"
#alias w='cd "$HOME/desktop/server" ; echo "$(hip) in $PWD" ; sudo python3 -m http.server 80'
#alias w2='cd "$HOME/desktop/server" ; echo "$(hip) in $PWD" ; sudo python3 -m http.server 8000'
#alias w3='ngrok http 4444'

# Show current network connections to the server
alias nethog='sudo nethogs'
alias ipview="netstat -anpl | grep :80 | awk {'print \$5'} | cut -d\":\" -f1 | sort  | uniq -c | sort -n | sed -e 's/^ *//' -e 's/ *\$//'"
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
alias gm='git add . && echo -n "Enter commit message: " && read msg && git commit -m "$msg" && git push'
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
alias diffbin="cmp"
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
# DEBIAN SPECIFIC                                                                                            #
##############################################################################################################
# Apt-get
#alias deb-version="lsb_release -a"                                 # check system version
#alias deb-upgrade="sudo apt update && sudo apt full-upgrade -y"    # Upgrade to the latest kali version
#alias apti="sudo apt update && sudo apt install"
#alias aptr="sudo apt update && sudo apt purge"          # Remove with its configuration files
#alias cleanup="sudo apt update && sudo apt autoremove"
#alias aptcache="sudo du -sh /var/cache/apt/archives"
#alias aptcache-clean="sudo apt clean"
#alias apts="sudo apt-cache search"
#alias rip-apt="sudo apt list --installed"
#alias rip-snap="snap list"
#alias apt-history='grep " install " /var/log/apt/history.log'

# System
#alias grubup="sudo update-grub"
#alias fd='fdfind'


##############################################################################################################
# ARCH SPECIFIC                                                                                              #
##############################################################################################################
# Blackarch repo packages
alias blackall="sudo pacman -Sgg | grep blackarch | cut -d' ' -f2 | sort -u"  # List all available tools
alias blackcat="sudo pacman -Sg | grep blackarch"                             # See the blackarch categories
alias btrfs-assistant="xhost +SI:localuser:root && sudo btrfs-assistant"                # btrfs-assistant package for restoring snapshats (timeshift replacement)
alias ginxi="garuda-inxi"
#alias gup="garuda-update"
alias gitpkg="pacman -Q | grep -i '\-git' | wc -l"
alias grubup="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias crackmapexec='snap run crackmapexec'
alias cme='snap run crackmapexec'
# Impacket scripts
alias impacket-secretsdump='secretsdump.py'
alias impacket-getadusers='GetADUsers.py'
alias impacket-smbserver='smbserver.py'
alias impacket-wmiexec='wmiexec.py'
alias impacket-getuserspns='GetUserSPNs.py'
alias impacket-ntlmrelayx='ntlmrelayx.py'
alias impacket-mssqlclient='mssqlclient.py'
alias impacket-samrdump='samrdump.py'
alias impacket-psexec='psexec.py'

# Refresh mirrorlists
alias rank-mirrors="sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak && sudo reflector --verbose --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist && cat /etc/pacman.d/mirrolist"
alias rank-mirrors-quick="sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup && sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.backup && sudo rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist"
# Get fastest mirrors
#alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
#alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
#alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
#alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

# Pacman
alias pacs="sudo pacman -S"                      # Install package faster
alias pacr="sudo pacman -Rns"                    # Remove package faster
alias pacf="sudo pacman -F"                      # Search binary package faster
alias pacu="sudo pacman -U"                      # Install the needed package
alias pacsyu="sudo pacman -Syuu"     # Update only standard pkgs
alias pacsyyu="sudo pacman -Syyu"                # Refresh pkglist & update standard pkgs
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)' # Cleanup orphaned packages

# Pacman issues
alias rmdblock="sudo rm /var/lib/pacman/db.lck"  # Fix “unable to lock database” Error
alias fix-keys="sudo pacman-key --init; sudo pacman-key --populate; sudo pacman-key --lsign cachyos"

# Paru
alias pars="paru -S"                              # Install AUR package faster
alias parr="paru -Rns"                            # Remove package faster
alias parf="paru -F"                              # Search binary package faster
alias parsyu="~/.config/.local/bin/sys-update.sh" # Update standard pkgs and AUR pkgs
alias parsyur="paru -Syuu && sleep 5 && reboot"        # Update and reboot
alias parsyus="paru -Syuu && sleep 5 && shutdown now"  # Update and shutdown
alias parhi='paru -Ql'                            # Paru Has Installed - what files where installed in a package
alias parss='paru -Ss'                            # Search
alias parc='paru -Sc'                             # Remove pacman's cache
alias parro='paru -Rns $(pacman -Qtdq)'
alias parls="paru -Qe"

# Revert to an older version of the package
alias pkgver="cd /var/cache/pacman/pkg && lsd -l --hyperlink=auto"     # Go into the pacman cache and find the needed package.
alias paruu="sudo pacman -U package"


##############################################################################################################
# Aliases to modified commands                                                                               #
##############################################################################################################
alias swappy='swappy -f'
alias s="kitty +kitten ssh"
alias ce='cheat --edit'
alias btree="cbonsai --live"
alias whisper='whisper --language en --output-format srt --model tiny'
alias aliases='nvim ~/.config/zsh/aliases.zsh'
alias hist='atuin history list --human'
alias stats='atuin stats'
alias pping="prettyping -c 3"
#alias pg='prettyping -c 3 8.8.8.8'
#alias less="less -R"   # have function as 'less'
alias wire-desktop='wire-desktop --password-store="gnome-libsecret"'
alias fetch='clear && fastfetch --kitty ~/pictures/screeshots/Patrick-Bateman-Profile-Pic_600x600.jpg && echo && fortune ~/.config/fortune/quotes'
alias mfetch='macchina'
alias ofetch='onefetch'
#alias pfetch='pfetch'
alias devil="fortune ~/.config/fortune/quotes | cowsay -f eyes | lolcat"
alias matrix="cmatrix -a"
alias clock="tty-clock -c -C 4 -r -s -f \"%A, %B, %d\""
alias asciiquarium="asciiquarium --transparent"
alias h2t="html2text -style pretty"
alias x2h="xsltproc -o result.html"
alias e="emacsclient -nw"
alias v="nvim"
#alias docker="sudo docker"
alias norg="gron --ungron"
alias ungron="gron --ungron"
alias waybar-toggle="killall -SIGUSR1 waybar"
alias exif-rm-data="exiftool -all= yourfile.pdf"
alias open='xdg-open'
alias da='date "+%Y-%m-%d %A %T %Z"'
alias update-fc='sudo fc-cache -fv'
alias jctl="journalctl -p 3 -xb"
alias jctle="journalctl --user -xeu"    # show error messages, specify a unit
alias n="bat /tmp/notify.log"
alias okitty='kitty -o allow_remote_control=yes --single-instance --listen-on unix:@mykitty'
alias lsall="lspci"
alias mic-record="pw-record ./recording.mp3"
alias gparted="xhost +SI:localuser:root && gparted"    # Optionally try running ocmmand: "xhost +localhost" and then "sudo gparted"
alias fluxion='xhost +SI:localuser:root && sudo fluxion'
alias nmap="grc nmap"
alias 7z-file="7z l -slt"             # exampine the .zip file
alias ssp="searchsploit"
alias tre="trans en:pl"
alias trp="trans pl:en"
alias empire="sudo powershell-empire client"
alias ms='systemctl postgresql start ; msfdb init ; msfconsole'
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

# Using AMD P-State EPP scheduler and omen laptop settings
alias pstate='cat /sys/devices/system/cpu/amd_pstate/status'     # Check if the state of p-state driver
alias powersave='sudo auto-cpufreq --force=powersave && sudo cpupower --cpu all frequency-set -g powersave'
alias performance='sudo auto-cpufreq --force=performance && sudo cpupower --cpu all frequency-set -g performance'
alias cpu-reset='sudo auto-cpufreq --force=reset'
# Fan management
alias fans='watch sudo omen-fan i'
alias cpu-temp='sensors zenpower-pci-00c3'
alias watch-cpu-temp='watch sensors zenpower-pci-00c3'         # Watch the CPU thermals
alias watch-fans='watch sudo omen-fan i'                       # Watch the service status and bios control status
alias omen-fan-on='sudo omen-fan e 1'                          # Start the fan management service (disables BIOS control)
alias omen-fan-off='sudo omen-fan e 0'                         # Stop the fan management serivce (enables BIOS control)
alias omen-fan-set='sudo omen-fan e 0 && sudo omen-fan s'      # Stop the fan management service and set fan speed (disables BIOS control)
alias omen-fan-boost-on='sudo omen-fan x 1'                    # Enable the fan boost (ignores BIOS control and fan management service)
alias omen-fan-boost-off='sudo omen-fan x 0'                   # Disable the fan boost

# Hblock (stop tracking with hblock) - use unhblock to stop using hblock
alias unhblock="hblock -S none -D none"
