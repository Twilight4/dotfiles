#!/usr/bin/env zsh

# XDG 
export XDG_CONFIG_HOME="$HOME/.config"               # For dotfiles
export XDG_DATA_HOME="$XDG_CONFIG_HOME/.local/share" # For specific data
export XDG_CACHE_HOME="$XDG_CONFIG_HOME/cache"       # For cached files
export XDG_STATE_HOME="$HOME/.local/state"           # For state files
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"      # Xauth file

# User-specific environment variables (system-wide are located in /etc/environment)
export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="footclient"
export BROWSER="librewolf"

# Zsh
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"                # Zsh config files
export HISTFILE="$ZDOTDIR/.zhistory"                 # History filepath
export HISTSIZE=10000                                # Maximum events for internal history
export SAVEHIST=10000                                # Maximum events in history file

# Other softwares
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export LESSHISTFILE="$XDG_CACHE_HOME"/less/history
export TMUXP_CONFIGDIR="$XDG_CONFIG_HOME/tmuxp"
export _Z_DATA="$XDG_DATA_HOME/z/"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export XCURSOR_PATH=/usr/share/icons:${XDG_DATA_HOME}/icons

# FZF
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Colorize FZF
FZF_COLORS="bg+:-1,\
fg:gray,\
fg+:white,\
border:black,\
spinner:0,\
hl:yellow,\
header:blue,\
info:green,\
pointer:red,\
marker:red,\
prompt:gray,\
hl+:red"

export FZF_DEFAULT_OPTS="--height 60% \
--border sharp \
--color='$FZF_COLORS' \
--prompt '∷ ' \
--pointer ▶ \
--marker ⇒"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -n 10'"

# Man pages
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# Nnn
export NNN_BMS="h:~;d:~/Documents;D:~/Downloads;w:~/.config/hypr/wallpapers;m:~/Music/"
export NNN_TRASH=1
export NNN_PLUG='o:fzopen;c:fzcd;z:jump;p:preview-tui;t:preview-tabbed;i:imgview;v:vidthumb;d:dragd;x:!chmod +x $nnn'
export NNN_FIFO='/tmp/nnn.fifo'
export SPLIT='v'

# Payloads vars
export PAYLOADS="/usr/share/payloads"
export SECLISTS="$PAYLOADS/SecLists"
export PAYLOADSALLTHETHINGS="$PAYLOADS/PayloadsAllTheThings"
export FUZZDB="$PAYLOADS/FuzzDB"
export AUTOWORDLISTS="$PAYLOADS/Auto_Wordlists"
export SECURITYWORDLIST="$PAYLOADS/Security-Wordlist"
export MIMIKATZ="/usr/share/windows/mimikatz/"
export POWERSPLOIT="/usr/share/windows/powersploit/"
export ROCKYOU="$SECLISTS/Passwords/Leaked-Databases/rockyou.txt"
export DIRSMALL="$SECLISTS/Discovery/Web-Content/directory-list-2.3-small.txt"
export DIRMEDIUM="$SECLISTS/Discovery/Web-Content/directory-list-2.3-medium.txt"
export DIRBIG="$SECLISTS/Discovery/Web-Content/directory-list-2.3-big.txt"
export WEBAPI_COMMON="$SECLISTS/Discovery/Web-Content/api/api-endpoints.txt"
export WEBAPI_MAZEN="$SECLISTS/Discovery/Web-Content/common-api-endpoints-mazen160.txt"
export WEBCOMMON="$SECLISTS/Discovery/Web-Content/common.txt"
export WEBPARAM="$SECLISTS/Discovery/Web-Content/burp-parameter-names.txt"
