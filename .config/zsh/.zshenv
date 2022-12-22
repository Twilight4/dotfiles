#!/usr/bin/env zsh

# XDG 
export XDG_CONFIG_HOME="$HOME/.config"               # For dotfiles
export XDG_DATA_HOME="$XDG_CONFIG_HOME/.local/share" # For specific data
export XDG_CACHE_HOME="$XDG_CONFIG_HOME/cache"       # For cached files
export XDG_STATE_HOME="$HOME/.local/state"           # For state files

# Environment variables
export EDITOR="emacs"
export VISUAL="emacs"
export TERMINAL="kitty"
export BROWSER="librewolf"

# X11 - I use wayland
#export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"
#export XINITRC="$XDG_CONFIG_HOME/x11/xinitrc"

# Zsh
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"                # Zsh config files
export HISTFILE="$ZDOTDIR/.zhistory"                 # History filepath
export HISTSIZE=10000                                # Maximum events for internal history
export SAVEHIST=10000                                # Maximum events in history file

# Other software
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

# Colorize man pages
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'
