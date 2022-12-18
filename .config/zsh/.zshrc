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

# Colors
autoload -Uz colors && colors

# Profiling
zmodload zsh/zprof

# Source plugin manager
source "$ZDOTDIR/functions.zsh"

# Source files from main directory
zsh_add_file "aliases.zsh"
zsh_add_file "scripts.zsh"
zsh_add_file "fzf-scripts.zsh"
zsh_add_file "completion.zsh"
zsh_add_file "bindings.zsh"
# Source additional files from plugins directory
zsh_add_file "vim-mode"
zsh_add_file "cursor-mode"
zsh_add_file "bd.zsh"
# Source prompt
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# Install plugins
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
zsh_add_plugin "hlissner/zsh-autopair"
zsh_add_plugin "agkozak/zsh-z"
#zsh_add_plugin "sinetoami/web-search"
#zsh_add_plugin "ohmyzsh/copybuffer"
#zsh_add_plugin "ohmyzsh/copydir"
#zsh_add_plugin "ohmyzsh/dirhistory"
zsh_add_completion "zsh-users/zsh-completions"
# For more plugins: https://github.com/unixorn/awesome-zsh-plugins
# More completions https://github.com/zsh-users/zsh-completions

zle -N fg-bg
bindkey '^Z' fg-bg
bindkey -r '^l'              #rebinding clear from ctrl + l to ctrl + g
bindkey -r '^g'              #rebinding clear from ctrl + l to ctrl + g
bindkey '^g' .clear-screen   #rebinding clear from ctrl + l to ctrl + g
bindkey '^x' fzf-cd-widget   #bind ctrl+x to do the same as alt+c in fzf

#bindkey -r '^p'
#bindkey -s '^p' 'fpdf\n'

#bindkey -r '^f'
#bindkey -s '^f' 'fmind\n'

#bindkey -r '^y'
#bindkey -s '^y' 'htop^M'

bindkey -r '^u'
bindkey -s '^u' 'duf^M'

#bindkey -r '^i'
#bindkey -s '^i' 'vtop^M'

bindkey -r '^o' 
bindkey -s '^o' 'lf^M'

# FZF
if [ $(command -v "fzf") ]; then
source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh
fi

# Speedy keys
xset r rate 210 40

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

# Tmuxp
#ftmuxp

source $XDG_CONFIG_HOME/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
