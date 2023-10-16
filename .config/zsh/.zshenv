#!/usr/bin/env zsh

# XDG 
export XDG_CONFIG_HOME="$HOME/.config"               # For dotfiles
export XDG_DATA_HOME="$XDG_CONFIG_HOME/.local/share" # For specific data
export XDG_CACHE_HOME="$XDG_CONFIG_HOME/cache"       # For cached files
export XDG_STATE_HOME="$HOME/.local/state"           # For state files

# User-specific environment variables (system-wide are located in /etc/environment)
export EDITOR="emacsclient -c -a emacs"
export ALTERNATE_EDITOR=""
export VISUAL="kitty -1 -c ~/.config/kitty/kitty-emacs.conf --class kitty-emacs -T kitty-emacs -e 'emacs -nw'"
export TERMINAL="kitty -1"
export BROWSER="firefox"

# Zsh
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"                		 # Zsh config files
export HISTCONTROL=ignoreboth       		                 # Ignore commands that start with spaces and duplicates
export HISTIGNORE="&:[bf]g:clear:history:exit:q:pwd:* --help"    # Dont add certain commands to the history file
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"  		 # Make new shells get the history lines from all previous shells instead of the default "last window closed" history
export HISTFILE="$ZDOTDIR/.zhistory"                 		 # History filepath
export HISTSIZE=10000                                		 # Maximum events for internal history
export SAVEHIST=10000                                		 # Maximum events in history file

# NPM
export NPM_PATH="$XDG_CONFIG_HOME/node_modules"
export NPM_BIN="$XDG_CONFIG_HOME/node_modules/bin"
export NPM_CONFIG_PREFIX="$XDG_CONFIG_HOME/node_modules"

# Other softwares
export NIMBLE_DIR="$XDG_DATA_HOME/nimble"
export LESSHISTFILE="$XDG_STATE_HOME"/less/history
export GOPATH="$XDG_DATA_HOME"/go
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export TMUXP_CONFIGDIR="$XDG_CONFIG_HOME/tmuxp"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export XCURSOR_PATH=/usr/share/icons:$XDG_DATA_HOME/icons
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc
export BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME"/bundle
export BUNDLE_USER_CACHE="$XDG_CACHE_HOME"/bundle
export BUNDLE_USER_PLUGIN="$XDG_DATA_HOME"/bundle
export PSQL_HISTORY="$XDG_DATA_HOME/psql_history"

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
export FZF_COMPLETION_DIR_COMMANDS="cd pushd rmdir tree ls"

# Man pages
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# Nnn
export NNN_BMS="d:~/documents;D:~/downloads;w:~/workspace;h:~/.config/hypr;m:~/music;p:~/pictures;c:~/.config;v:~/videos;s:~/.config/.local/share/navi/cheats/Twilight4;o:/opt;r:/run/media/twilight"
export NNN_TRASH=1
export NNN_PLUG='b:bulknew;o:fzopen;c:fzcd;j:autojump;p:preview-tui;i:imgview;u:upload;f:fixname;d:dragdrop;x:imgur;g:gsconnect:'
#export NNN_FCOLORS='00000E6310000000000000000'
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
