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
#stty stop undef                        # Disable ctrl-s to freeze terminal.
zle_highlight=('paste:none')

# beeping is annoying
unsetopt beep

# completions
autoload -Uz compinit; compinit
zstyle ':completion:*' menu select
# zstyle ':completion::complete:lsof:*' menu yes select
zmodload zsh/complist
# compinit
_comp_options+=(globdots)               # Include hidden files.

# Colors
autoload -Uz colors && colors

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

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
zsh_add_file "zsh-vim-mode"

# Plugins
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
zsh_add_plugin "hlissner/zsh-autopair"
zsh_add_plugin "agkozak/zsh-z"
zsh_add_plugin "Tarrasch/zsh-bd"
#zsh_add_plugin "sinetoami/web-search"
#zsh_add_plugin "ohmyzsh/copybuffer"
#zsh_add_plugin "ohmyzsh/copydir"
#zsh_add_plugin "ohmyzsh/dirhistory"
zsh_add_completion "zsh-users/zsh-completions"
# For more plugins: https://github.com/unixorn/awesome-zsh-plugins
# More completions https://github.com/zsh-users/zsh-completions

# Key-bindings (commented are without vi mode)
#bindkey '^'          kill-word                      #unassigned
#bindkey '^[[H'       beginning-of-line              #Home
#bindkey '^[[F'       end-of-line                    #End
#bindkey '^K'         kill-line                      #Ctrl+K
#bindkey '^U'         backward-kill-line             #Ctrl+U
#bindkey '^[[Z'       undo                           #Shift + tab
#bindkey '^[[1;5C]'   forward-word                   #Ctrl+LeftArrow
#bindkey '^[[1;5D]'   backward-word                  #Ctrl+RightArrow

bindkey '^[[D'       backward-char                          #LeftArrow
bindkey '^[[C'       forward-char                           #RightArrow
bindkey '^W'         backward-kill-word                     #Ctrl+W
bindkey '^[[3~'      delete-char                            #Delete
bindkey '^?'         backward-delete-char                   #Backspace
bindkey '^[[5~'      beginning-of-buffer-or-history         #PgUp
bindkey '^[[6~'      end-of-buffer-or-history               #PgDn
bindkey '^k'         up-line-or-beginning-search            #Up
bindkey '^j'         down-line-or-beginning-search          #Down

#bindkey -s '^y' 'htop^M'
#bindkey -s '^u' 'ncdu^M'
#bindkey -s '^i' 'ncdu^M'
#bindkey -s '^o' 'lf^M'
#bindkey -s '^p' 'ncdu^M'


# Edit line in set $EDITOR with 'g' key in NORMAL mode
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd g edit-command-line

# Speedy keys
xset r rate 210 40

# Environment variables set everywhere
export EDITOR="nvim"
export TERMINAL="alacritty"
export BROWSER="firefox"

# For QT Themes
export QT_QPA_PLATFORMTHEME=qt5ct
source /opt/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
