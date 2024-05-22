#!/usr/bin/env zsh

# XDG 
export XDG_CONFIG_HOME="$HOME/.config"               # For dotfiles
export XDG_DATA_HOME="$XDG_CONFIG_HOME/.local/share" # For specific data
export XDG_CACHE_HOME="$XDG_CONFIG_HOME/cache"       # For cached files
export XDG_STATE_HOME="$HOME/.local/state"           # For state files

# User-specific environment variables (system-wide are located in /etc/environment)
export EDITOR="emacsclient -nw"
export ALTERNATE_EDITOR=""
export VISUAL="emacsclient -nw"
export TERMINAL="kitty -1"
export BROWSER="floorp"

# User-defined PATH executables
export PATH=$HOME/.config/hypr/scripts:$HOME/.local/bin:$HOME/.config/.local/share/cargo/bin:$HOME/.config/.local/bin:$HOME/.config/zsh/bash-scripts:$HOME/.config/rofi/bin:$HOME/.config/node_modules/.bin:$PATH

# Zsh
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"                		 # Zsh config files
export HISTCONTROL=ignoreboth       		                 # Ignore commands that start with spaces and duplicates
export HISTIGNORE="&:[bf]g:clear:history:exit:q:pwd:* --help"    # Dont add certain commands to the history file
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"  		 # Make new shells get the history lines from all previous shells instead of the default "last window closed" history
export HISTFILE="$ZDOTDIR/.zhistory"                 		 # History filepath
export HISTSIZE=10000                                		 # Maximum events for internal history
export SAVEHIST=10000                                		 # Maximum events in history file
export HISTDUP=erase                                     # Remove duplicates from history file

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

# Bat theme
export BAT_THEME="tokyonight_night"

# FZF
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -l -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=snip --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'exa --tree --icons --group-directories-first --git-ignore --level 2 --color=always {} | head -n 100'"
export FZF_COMPLETION_DIR_COMMANDS="cd pushd rmdir tree ls"
export LESSOPEN='| ~/.config/zsh/fzf-scripts/less-filter-fzf.sh %s'
export ENHANCD_FILTER="fzf --preview 'exa --icons --tree --group-directories-first --git-ignore --level 2 --color=always {}'"
export ENHANCD_DIR="$HOME/.config/.enhancd"
export ENHANCD_HOOK_AFTER_CD="ls"
export ENHANCD_HYPHEN_NUM="15"
#export ENHANCD_USE_ABBREV="true"          # breaks the fzf preview

# Colorize FZF
FZF_COLORS="bg+:-1,\
fg:gray,\
fg+:#87afff,\
border:black,\
spinner:0,\
hl:yellow,\
header:blue,\
info:cyan,\
pointer:red,\
marker:red,\
prompt:blue,\
hl+:red"

export FZF_DEFAULT_OPTS="--height 60% \
--border sharp \
--multi \
--no-mouse \
--reverse \
--margin=0,1 \
--color='$FZF_COLORS' \
--bind 'ctrl-d:preview-down,ctrl-u:preview-up,ctrl-f:preview-page-down,ctrl-b:preview-page-up,ctrl-/:toggle-preview' \
--bind 'pgdn:preview-page-down,pgup:preview-page-up' \
--prompt '❯ ' \
--no-separator --scrollbar="█" \
--pointer ▶ \
--marker '✚ '"

# Man pages
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# Nnn
export NNN_BMS="d:~/documents;D:~/downloads;w:~/desktop/workspace;h:~/.config/hypr;m:~/music;p:~/pictures;c:~/.config;v:~/videos;o:/opt;r:/run/media/twilight"
export NNN_TRASH=1
export NNN_PLUG='b:bulknew;o:fzopen;c:fzcd;j:autojump;p:preview-tui;i:imgview;u:upload;f:fixname;d:dragdrop;x:imgur;g:gsconnect:'
#export NNN_FCOLORS='00000E6310000000000000000'
export NNN_FIFO='/tmp/nnn.fifo'
export SPLIT='v'

# Project vars
export PJ="$HOME/desktop/projects"
export WS="$HOME/desktop/workspace"
export SV="$HOME/desktop/server"
export DW="$HOME/downloads"
export VD="$HOME/videos"
export DT="$HOME/desktop"
export DC="$HOME/documents"
export ORG="$HOME/documents/org"
export PC="$HOME/pictures"
export SC="$HOME/pictures/screenshots"
export WORDLISTS="/usr/share/wordlists/"
export SECLISTS="$WORDLISTS/seclists"
export PAYLOADSALLTHETHINGS="$WORDLISTS/PayloadsAllTheThings"
export FUZZDB="$WORDLISTS/FuzzDB"
export AUTOWORDLISTS="$WORDLISTS/Auto_Wordlists"
export SECURITYWORDLIST="$WORDLISTS/Security-Wordlist"
export MIMIKATZ="/usr/share/windows-resources/mimikatz/"
export POWERSPLOIT="/usr/share/windows-resources/powersploit/"
