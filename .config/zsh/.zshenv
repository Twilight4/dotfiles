# For dotfiles
export XDG_CONFIG_HOME="$HOME/.config"

# For specific data
export XDG_DATA_HOME="$XDG_CONFIG_HOME/local/share"

# For cached files
export XDG_CACHE_HOME="$XDG_CONFIG_HOME/cache"

# For state files
export XDG_STATE_HOME="$XDG_CONFIG_HOME/local/state"

# Environment variables for launching text editor
export EDITOR="nvim"
export VISUAL="nvim"

# $ZDOTDIR - Config files for zsh
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# For Xauthority
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"

# For xinit
export XINITRC="$XDG_CONFIG_HOME/x11/xinitrc"

# History filepath
export HISTFILE="$ZDOTDIR/.zhistory"

# Maximum events for internal history
export HISTSIZE=10000

# Maximum events in history file
export SAVEHIST=10000
