###########
# General #
###########
# Load more completions
fpath=($XDG_CONFIG_HOME/zsh/plugins/zsh-completions/src $fpath)

local cheats taglist pathlist

_cheat_complete_personal_cheatsheets()
{
  cheats=("${(f)$(cheat -l -t personal | tail -n +2 | cut -d' ' -f1)}")
  _describe -t cheats 'cheats' cheats
}

_cheat_complete_full_cheatsheets()
{
  cheats=("${(f)$(cheat -l | tail -n +2 | cut -d' ' -f1)}")
  _describe -t cheats 'cheats' cheats
}

_cheat_complete_tags()
{
  taglist=("${(f)$(cheat -T)}")
  _describe -t taglist 'taglist' taglist
}

_cheat_complete_paths()
{
  pathlist=("${(f)$(cheat -d | cut -d':' -f1)}")
  _describe -t pathlist 'pathlist' pathlist
}

_cheat() {

  _arguments -C \
    '(--init)--init[Write a default config file to stdout]: :->none' \
    '(-c --colorize)'{-c,--colorize}'[Colorize output]: :->none' \
    '(-d --directories)'{-d,--directories}'[List cheatsheet directories]: :->none' \
    '(-e --edit)'{-e,--edit}'[Edit <sheet>]: :->personal' \
    '(-l --list)'{-l,--list}'[List cheatsheets]: :->full' \
    '(-p --path)'{-p,--path}'[Return only sheets found on path <name>]: :->pathlist' \
    '(-r --regex)'{-r,--regex}'[Treat search <phrase> as a regex]: :->none' \
    '(-s --search)'{-s,--search}'[Search cheatsheets for <phrase>]: :->none' \
    '(-t --tag)'{-t,--tag}'[Return only sheets matching <tag>]: :->taglist' \
    '(-T --tags)'{-T,--tags}'[List all tags in use]: :->none' \
    '(-v --version)'{-v,--version}'[Print the version number]: :->none' \
    '(--rm)--rm[Remove (delete) <sheet>]: :->personal' 

  case $state in
    (none)
      ;;
    (full)
      _cheat_complete_full_cheatsheets
      ;;
    (personal)
      _cheat_complete_personal_cheatsheets
      ;;
    (taglist)
      _cheat_complete_tags
      ;;
    (pathlist)
      _cheat_complete_paths
      ;;
    (*)
      ;;
  esac
}

# Should be called before compinit
zmodload zsh/complist

# Use hjlk in menu selection (during completion)
# Doesn't work well with interactive mode
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'l' vi-forward-char

bindkey -M menuselect '^xg' clear-screen
bindkey -M menuselect '^xi' vi-insert                      # Insert
bindkey -M menuselect '^xh' accept-and-hold                # Hold
bindkey -M menuselect '^xn' accept-and-infer-next-history  # Next
bindkey -M menuselect '^xu' undo                           # Undo

autoload -U compinit; compinit
_comp_options+=(globdots) # With hidden files

# automatically load bash completion functions
autoload -U +X bashcompinit && bashcompinit

# Only work with the Zsh function vman
# See $DOTFILES/zsh/scripts.zsh
compdef vman="man"

# load cheat completions
compdef _cheat cheat

# load wrapper script for hyperlinked grep
compdef _rg hg


###########
# Options #
###########
# setopt GLOB_COMPLETE      # Show autocompletion menu with globs
setopt MENU_COMPLETE        # Automatically highlight first element of completion menu
setopt AUTO_LIST            # Automatically list choices on ambiguous completion.
setopt COMPLETE_IN_WORD     # Complete from both ends of a word.


###########
# zstyles #
###########
# Ztyle pattern
# :completion:<function>:<completer>:<command>:<argument>:<tag>

# Define completers
zstyle ':completion:*' completer _expand _complete _ignored _approximate _extensions

# Use cache for commands using cache
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
# Complete the alias when _expand_alias is used as a function
zstyle ':completion:*' complete true

zle -C alias-expension complete-word _generic
bindkey '^Xa' alias-expension
zstyle ':completion:alias-expension:*' completer _expand_alias

# Allow you to select in a menu
zstyle ':completion:*' menu select

# Completions
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
#zstyle ':completion:*:*:*:*:default' list-colors ${(s.:.)LS_COLORS}     # Colors for files and directory

# fzf-tab configuration
# apply to all command minimum popup size
#zstyle ':fzf-tab:*' popup-min-size 50 8
# color when there is no group.
zstyle ':fzf-tab:*' default-color $'\033[0m'
# show systemd unit status
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'
zstyle ':fzf-tab:complete:*:*' fzf-preview 'less ${(Q)realpath}'
# environment variable
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
	fzf-preview 'echo ${(P)word}'
# tldr
zstyle ':fzf-tab:complete:tldr:argument-1' fzf-preview 'tldr --color always $word'
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'

# Autocomplete options for cd instead of directory stack
zstyle ':completion:*' complete-options true

zstyle ':completion:*' file-sort modification

# Must be off when using fzf-tab
#zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
#zstyle ':completion:*:*:*:*:descriptions' format '%F{blue}-- %D %d --%f'
#zstyle ':completion:*:*:*:*:messages' format ' %F{purple} -- %d --%f'
#zstyle ':completion:*:*:*:*:warnings' format ' %F{red}-- no matches found --%f'
# zstyle ':completion:*:default' list-prompt '%S%M matches%s'

# Only display some tags for the command cd
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
# zstyle ':completion:*:complete:git:argument-1:' tag-order !aliases

# Required for completion to be in good groups (named after the tags)
zstyle ':completion:*' group-name ''

zstyle ':completion:*:*:-command-:*:*' group-order aliases builtins functions commands

# See ZSHCOMPWID "completion matching control"
zstyle ':completion:*' rehash true                              # automatically find new executables in path 
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'

zstyle ':completion:*' keep-prefix true

zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

# Other
zstyle ':completion:*' use-compctl false  # zsh won't use deprecated compctl features for completion.
zstyle ':completion:*' verbose true       # enable verbose completion output 
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'   # autocompletion for kill command
