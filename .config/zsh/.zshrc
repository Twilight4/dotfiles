# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#!/bin/sh

# HISTORY FILE
HISTFILE=~/.config/zsh/.zsh-history
setopt appendhistory
HISTSIZE=1000
SAVEHIST=1000

# some useful options (man zshoptions)
setopt autocd extendedglob nomatch menucomplete
setopt interactive_comments
stty stop undef         # Disable ctrl-s to freeze terminal.
zle_highlight=('paste:none')

# beeping is annoying
unsetopt beep

# completions
autoload -Uz compinit
zstyle ':completion:*' menu select
# zstyle ':completion::complete:lsof:*' menu yes select
zmodload zsh/complist
# compinit
_comp_options+=(globdots)               # Include hidden files.

# Colors
autoload -Uz colors && colors

# Push the current directory visited on to the stack
setopt AUTO_PUSHD
# Do not store duplicate directories in the stack
setopt PUSHD_IGNORE_DUPS
# Do not print the directory stack after using pushd or popd
setopt PUSHD_SILENT



# Useful Functions
source "$ZDOTDIR/zsh-functions"

# Normal files to source
zsh_add_file "zsh-aliases"

# Plugins
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
zsh_add_plugin "hlissner/zsh-autopair"
#zsh_add_plugin "sinetoami/web-search"
#zsh_add_plugin "ohmyzsh/copybuffer"
#zsh_add_plugin "ohmyzsh/copydir"
#zsh_add_plugin "ohmyzsh/dirhistory"
#zsh_add_completion "example/githubrepo"
# For more plugins: https://github.com/unixorn/awesome-zsh-plugins
# More completions https://github.com/zsh-users/zsh-completions

# Key-bindings
bindkey '^[[D'   backward-char                  #LeftArrow
bindkey '^[[C'   forward-char                   #RightArrow
bindkey '^K'     forward-word                   #Ctrl+K
bindkey '^J'     backward-word                  #Ctrl+J
bindkey "^W"     backward-kill-word             #Ctrl+W
#bindkey "^"     kill-word                      #Ctrl+
bindkey '^H'     beginning-of-line              #Ctrl+H
bindkey '^L'     end-of-line                    #Ctrl+L
bindkey "^N"     kill-line                      #Ctrl+N
bindkey "^B"     backward-kill-line             #Ctrl+B
bindkey "^Z"     undo                           #Ctrl+Z
bindkey '^[[3~'  delete-char                    #Delete
bindkey '^?'     backward-delete-char           #Backspace
bindkey '^[[Z'   reverse-menu-complete          #Shift+Tab
bindkey '^[[5~'  beginning-of-buffer-or-history #PgUp
bindkey '^[[6~'  end-of-buffer-or-history       #PgDn

bindkey -s '^a' 'clear^M'
bindkey -s '^y' 'htop^M'
#bindkey -s '^u' 'ncdu^M'
#bindkey -s '^i' 'ncdu^M'
#bindkey -s '^o' 'lf^M'
#bindkey -s '^p' 'ncdu^M'

############################jak nie dziala zmodload ####################################
#autoload -U up-line-or-beginning-search
#autoload -U down-line-or-beginning-search
#zle -N up-line-or-beginning-search
#zle -N down-line-or-beginning-search
#######################################################################################


# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Speedy keys
xset r rate 210 40

# Environment variables set everywhere
export EDITOR="nvim"
export TERMINAL="alacritty"
export BROWSER="firefox"

# For QT Themes
export QT_QPA_PLATFORMTHEME=qt5ct
source ~/.config/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
