#!/usr/bin/env zsh

# ls to lsd
alias l='lsd'
alias ls='lsd -l'
alias la='lsd -la'
alias lt='lsd --tree'
alias lx='lsd -lXBh'                # sort by extension
alias lk='lsd -lSrh'                # sort by size
alias lc='lsd -lcrh'                # sort by change time
alias lu='lsd -lurh'                # sort by access time
alias lm='lsd -alh |more'           # pipe through 'more'
alias lf="lsd -l | egrep -v '^d'"   # files only
alias ldir="lsd -l | egrep '^d'"    # directories only

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
#receive the key of a developer
alias gpg-retrieve="gpg2 --keyserver-options auto-key-retrieve --receive-keys"
alias fix-gpg-retrieve="gpg2 --keyserver-options auto-key-retrieve --receive-keys"
alias fix-keyserver="[ -d ~/.gnupg ] || mkdir ~/.gnupg ; cp /etc/pacman.d/gnupg/gpg. conf ~/.gnupg/ ; echo 'done'"

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

# get fastest mirrors
#alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
#alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
#alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
#alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

# Zsh Directory Stack
alias d='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index
