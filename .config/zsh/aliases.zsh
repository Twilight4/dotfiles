#!/usr/bin/env zsh

# ls to lsd
alias l='lsd --hyperlink=auto'
alias cdl='() { cd "$1" && ls -l; }'
alias cl='clear ; lsd -l --hyperlink=auto'
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
alias dw='cd "$HOME/downloads" ; clear'
alias dt='cd "$HOME/desktop" ; clear'
alias pc='cd "$HOME/pictures" ; clear'
alias vd='cd "$HOME/videos" ; clear'
alias dc='cd "$HOME/documents" ; clear'
alias org='cd "$HOME/documents/org" ; clear ; lsd --tree --hyperlink=auto'
alias guorg='cd "$HOME/documents/org" ; git add . && git commit -m "update" && git push'

# Work dirs
alias pj='cd "$HOME/desktop/projects" ; clear'
alias lpj='lsd --tree --hyperlink=auto ~/desktop/projects'
alias ws='cd "$HOME/desktop/workspace" ; clear'

# Common usage
alias r='cd $HOME ; clear'
alias w='cd "$HOME/desktop/server" ; echo "$(hip) in $PWD" ; sudo python3 -m http.server 80'
alias w2='cd "$HOME/desktop/server" ; echo "$(hip) in $PWD" ; sudo python3 -m http.server 8000'
alias w3='ngrok http 4444'
alias s="kitty +kitten ssh"
alias m='service postgresql start ; msfdb init ; msfconsole'
alias ce='cheat --edit'

# List cheatsheets for tools
alias ltp='lsd --tree --hyperlink=auto ~/desktop/workspace/cheats/pentest'    # Pentest tools
alias ltw='lsd --tree --hyperlink=auto ~/desktop/workspace/cheats/web-app'    # Web app tools
alias ltr='lsd --tree --hyperlink=auto ~/desktop/workspace/cheats/red-team'   # Red team tools
alias ltf='lsd --tree --hyperlink=auto ~/desktop/workspace/cheats/forensics'  # Forensics tools
alias lto='lsd --tree --hyperlink=auto ~/desktop/workspace/cheats/other'      # Other tools

# Blackarch repo packages
alias blackall="sudo pacman -Sgg | grep blackarch | cut -d' ' -f2 | sort -u"  # List all available tools
alias blackcat="sudo pacman -Sg | grep blackarch"                             # See the blackarch categories

# Aliases to modified commands
alias mkdir="mkdir -p"
alias ping="prettyping -c 3"
alias less="less -R"
alias kill='killall -q'
alias tr="trash"
alias fetch='clear && neofetch && fortune ~/.config/fortune/quotes'
alias nfetch='clear && neofetch --kitty ~/pictures/bateman.png && fortune ~/.config/fortune/quotes'
alias devil="fortune ~/.config/fortune/quotes | cowsay -f eyes | lolcat"
alias cmatrix="cmatrix -a"
alias asciiquarium="asciiquarium --transparent"
alias free="free -m"
alias h2t="html2text -style pretty"
alias x2h="xsltproc -o result.html"
alias emc="emacsclient -c -a emacs"
alias docker="sudo docker"
alias biggest="du -h --max-depth=1 | sort -h"
alias norg="gron --ungron"
alias ungron="gron --ungron"
alias open='xdg-open'
alias sc='socat'
alias scat='socat'
alias da='date "+%Y-%m-%d %A %T %Z"'
alias update-fc='sudo fc-cache -fv'
alias jctl="journalctl -p 3 -xb"
alias sip='sort -n -u -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4'
alias wget='wget --hsts-file="$XDG_DATA_HOME/wget-hsts"'
alias cats='highlight -O ansi --force'
alias icat='kitty +kitten icat'
alias diff="kitty +kitten diff"
alias gdiff="git difftool --no-symlinks --dir-diff"

# Prettify help/cheat pages
alias bathelp='bat --plain --language=help'
c() {
  command cheat "$@" | bat --plain --language=help
}
help() {
    "$@" --help 2>&1 | bathelp
}
h() {
    "$@" --help 2>&1 | bathelp
}

# Rust replacements
alias cp='xcp'
alias http='xh'                # Curl replacement
alias httpd='http --download'  # Uses xh alias first if installed
alias cat='bat --paging=never --theme OneHalfDark'
alias dig='dog'
alias digs='dig +short'        # Uses dog alias first if installed
alias rg='rg --sort path'
alias du='dust'
alias ncdu="ncdu --color dark"
alias df='duf'
alias bat='bat --paging=never --theme OneHalfDark'

# Mpv
alias mpk='mpv --profile=sw-fast --vo=kitty'
alias mpvadd='mpv --ytdl'
alias mpvpl='mpv "$(yt-dlp -g --flat-playlist "$1")"'
alias mpa='mpv --no-video'
alias mpapl='mpv --no-video "$(yt-dlp -g -x --audio-format mp3 --flat-playlist "$1")"'

# Trans
alias tre='trans en:pl'
alias trp='trans pl:en'

# Check CPU mitigations vulnerabilities in microcode
alias microcode='grep . /sys/devices/system/cpu/vulnerabilities/*'

# Using AMD P-State EPP Driver
alias pstate='cat /sys/devices/system/cpu/amd_pstate/status'   # Check if the p-state driver is active
alias powersave='sudo cpupower frequency-set -g powersave'
alias performance='sudo cpupower frequency-set -g performance'

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

# Count all files (recursively) in the current folder
alias cf="bash -c \"for t in files links directories; do echo \\\$(find . -  type \\\${t:0:1} | wc -l) \\\$t; done 2> /dev/null\""

# Show current network connections to the server
alias nethog='sudo nethogs'
alias psnet="lsof -i -n | awk '/ESTABLISHED/ {print \$1}' | sort -u"
alias ipview="netstat -anpl | grep :80 | awk {'print \$5'} | cut -d\":\" -f1 | sort  | uniq -c | sort -n | sed -e 's/^ *//' -e 's/ *\$//'"
alias wlo1='echo $(ifconfig wlo1 | rg "inet " | cut -b 9- | cut  -d" " -f2)'
alias tun0='echo $(ifconfig tun0 | rg "inet " | cut -b 9- | cut  -d" " -f2)'
 
# Show open ports
alias openports='netstat -nape --inet'

# Show disk space and space used in a folder
alias diskspace="du -S | sort -n -r |less -R"
alias folders='du -h --max-depth=1'
alias folderssort='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'
alias tree='tree -CAhF --dirsfirst'
alias treed='tree -CAFd'

# Show all logs in /var/log
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -  f1 | sed -e's/:\$//g' | grep -v '[0-9]\$' | xargs tail -f"

# Usefull
alias ..="cd ../"
alias ...="cd ../../"
alias ....="cd ../../../"

# Git
alias gc="git clone --depth 1"
alias gci="cloneit"
alias gu='git add . && git commit -m "update" && git push'
alias rmgitcache="rm -r ~/.cache/git"
alias gcm="git checkout master"
alias gcs="git checkout stable"

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
alias parsyu="paru -Syuu --noconfirm"              # Update standard pkgs and AUR pkgs
alias parsyur="sudo pacman --noconfirm -Syuu && sleep 5 && reboot"        # Update and reboot
alias parsyus="sudo pacman --noconfirm -Syuu && sleep 5 && shutdown now"  # Update and shutdown

# Revert to an older version of the package
alias pkgver="cd /var/cache/pacman/pkg && lsd -l --hyperlink=auto"     # Go into the pacman cache and find the needed package.
alias paruu="sudo pacman -U package"

# Quick access to config files - have these aliases bound keybinds in dired
alias zshrc="emacsclient -nw ~/.config/zsh/.zshrc"
alias aliases="emacsclient -nw ~/.config/zsh/aliases.zsh"
alias init="emacsclient -nw ~/.config/river/init"

# Colorize grep output
alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
alias fgrep="fgrep --color=auto"

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
