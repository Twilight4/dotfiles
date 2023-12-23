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
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
setopt appendhistory             # Immediately append history instead of overwriting
setopt histignorealldups         # If a new command is a duplicate, remove the older one

# Navigation
setopt nocaseglob           # Case insensitive globbing
setopt rcexpandparam        # Array expension with parameters
setopt nocheckjobs          # Don't warn about running processes when exiting
setopt numericglobsort      # Sort filenames numerically when it makes sense
setopt autocd               # if only directory path is entered, cd there.
setopt pushdminus
setopt AUTO_PUSHD           # Push the current directory visited on to the stack
setopt PUSHD_IGNORE_DUPS    # Do not store duplicate directories in the stack
setopt PUSHD_SILENT         # Do not print the directory stack after using pushd or popd
setopt extendedglob         # Extended globbing. Allows using regular expressions with *
setopt INTERACTIVE_COMMENTS # Enable comments when running an interactive session
setopt CORRECT              # Spelling correction
setopt nobeep               # No beep

# Uncomment the following line if pasting URLs and other text is messed up
DISABLE_MAGIC_FUNCTIONS="true"

# Colors
autoload -Uz colors && colors

# thefuck alias
eval $(thefuck --alias)

# Profiling
zmodload zsh/zprof

# Source plugin manager
source "$ZDOTDIR/functions.zsh"

# Source files from main directory
zsh_add_file "aliases.zsh"
zsh_add_file "scripts.zsh"
zsh_add_file "scripts-pentest.zsh"
zsh_add_file "fzf-scripts.zsh"
zsh_add_file "completion.zsh"
zsh_add_file "bindings.zsh"
# Source additional files from plugins directory
#zsh_add_file "vim-mode"
#zsh_add_file "cursor-mode"
zsh_add_file "quiver"
zsh_add_file "emacs-mode"
zsh_add_file "bd.zsh"
# Source prompt
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# Install plugins
zsh_add_plugin "b4b4r07/enhancd"
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
zsh_add_plugin "hlissner/zsh-autopair"
zsh_add_plugin "Twilight4/quiver-arch"
#zsh_add_plugin "kutsan/zsh-system-clipboard"  # for vim-mode
zsh_add_plugin "unixorn/prettyping"
#zsh_add_plugin "zshzoo/copier"
zsh_add_completion "zsh-users/zsh-completions"
# For more plugins: https://github.com/unixorn/awesome-zsh-plugins
# More completions https://github.com/zsh-users/zsh-completions

# Keybindings - check functions.zsh and emacs-mode for more
source "$ZDOTDIR/plugins/fg-bg.sh"
source "$ZDOTDIR/plugins/enhancd/init.sh"
zle -N fg-bg
bindkey '^Z' fg-bg

# Improved backward kill word
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# FZF
if [ $(command -v "fzf") ]; then
source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh
fi

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

## Plugins section: Enable fish style features
#source $XDG_CONFIG_HOME/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#source $XDG_CONFIG_HOME/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

# Use fzf
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# Arch Linux command-not-found support, you must have package pkgfile installed
# https://wiki.archlinux.org/index.php/Pkgfile#.22Command_not_found.22_hook
[[ -e /usr/share/doc/pkgfile/command-not-found.zsh ]] && source /usr/share/doc/pkgfile/command-not-found.zsh

# Advanced command-not-found hook
[[ -e /usr/share/doc/find-the-command/ftc.zsh ]] && source /usr/share/doc/find-the-command/ftc.zsh

# Load Mcfly
export MCFLY_FUZZY=true
export MCFLY_RESULTS=20
export MCFLY_INTERFACE_VIEW=BOTTOM
export MCFLY_RESULTS_SORT=LAST_RUN
eval "$(mcfly init zsh)"

# Fortune
#fortune ~/.config/fortune/quotes | cowsay -f eyes | lolcat

