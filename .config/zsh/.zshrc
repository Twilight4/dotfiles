#!/usr/bin/env zsh

# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# History
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.

# Navigation
setopt AUTO_PUSHD           # Push the current directory visited on to the stack
setopt PUSHD_IGNORE_DUPS    # Do not store duplicate directories in the stack
setopt PUSHD_SILENT         # Do not print the directory stack after using pushd or popd
setopt EXTENDED_GLOB        # Use extended globbing syntax
setopt INTERACTIVE_COMMENTS # Enable comments when running an interactive session
setopt CORRECT              # Spelling correction
setopt nobeep               # No beep

# Completions
autoload -Uz compinit; compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
_comp_options+=(globdots)               # Include hidden files.
zle_highlight=('paste:none')

# Colors
autoload -Uz colors && colors

# My plugin manager and p10k
source "$ZDOTDIR/zsh-functions"
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# Normal files to source
zsh_add_file "zsh-aliases"
zsh_add_file "zsh-vim-mode"
zsh_add_file "zsh-scripts"
zsh_add_file "zsh-fzf-scripts"

# Plugins
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
zsh_add_plugin "hlissner/zsh-autopair"
zsh_add_plugin "agkozak/zsh-z"
zsh_add_plugin "Tarrasch/zsh-bd"
source $XDG_CONFIG_HOME/zsh/plugins/zsh-bd/bd.zsh
source $XDG_CONFIG_HOME/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#zsh_add_plugin "sinetoami/web-search"
#zsh_add_plugin "ohmyzsh/copybuffer"
#zsh_add_plugin "ohmyzsh/copydir"
#zsh_add_plugin "ohmyzsh/dirhistory"
zsh_add_completion "zsh-users/zsh-completions"
# For more plugins: https://github.com/unixorn/awesome-zsh-plugins
# More completions https://github.com/zsh-users/zsh-completions

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[D'       backward-char                          # LeftArrow
bindkey '^[[C'       forward-char                           # RightArrow
bindkey '^_'         forward-char                           # RightArrow
bindkey '^[[Z'       reverse-menu-complete                  # Shift+tab
bindkey '^W'         backward-kill-word                     # Ctrl+W
bindkey '^[[3~'      delete-char                            # Delete
bindkey '^?'         backward-delete-char                   # Backspace
bindkey '^[[5~'      beginning-of-buffer-or-history         # PgUp
bindkey '^[[6~'      end-of-buffer-or-history               # PgDn
bindkey '^k'         up-line-or-beginning-search            # Up
bindkey '^j'         down-line-or-beginning-search          # Down

zle -N fg-bg
bindkey '^Z' fg-bg
bindkey -r '^l'              #rebinding clear from ctrl + l to ctrl + n
bindkey -r '^n'              #rebinding clear from ctrl + l to ctrl + n
bindkey '^n' .clear-screen   #rebinding clear from ctrl + l to ctrl + n
bindkey '^x' fzf-cd-widget   #bind ctrl+x to do the same as alt+c in fzf
#bindkey -r '^p'
#bindkey -s '^p' 'fpdf\n'
#bindkey -r '^f'
#bindkey -s '^f' 'fmind\n'
#bindkey -r '^w'
#bindkey -s '^w' 'fwork\n'
#bindkey -s '^y' 'htop^M'
#bindkey -s '^u' 'ncdu^M'
#bindkey -s '^i' 'ncdu^M'
#bindkey -s '^o' 'lf^M'
#bindkey -s '^p' 'ncdu^M'

# FZF
if [ $(command -v "fzf") ]; then
source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh
fi

# Edit line in set $EDITOR with 'g' key in NORMAL mode
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd g edit-command-line

# Speedy keys
xset r rate 210 40

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

# Tmuxp
#ftmuxp
