#!/usr/bin/env zsh

# ─────────────────────────────────────────────
# HISTORY
# ─────────────────────────────────────────────
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY

# ─────────────────────────────────────────────
# NAVIGATION
# ─────────────────────────────────────────────
setopt nocaseglob
setopt rcexpandparam
setopt nocheckjobs
setopt numericglobsort
setopt autocd
setopt pushdminus
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt extendedglob
setopt INTERACTIVE_COMMENTS
setopt CORRECT
setopt nobeep
setopt magicequalsubst
setopt nonomatch
setopt notify
setopt PROMPT_SUBST

# ─────────────────────────────────────────────
# CORE ZSH INIT
# ─────────────────────────────────────────────
# Uncomment the following line if pasting URLs and other text is messed up
DISABLE_MAGIC_FUNCTIONS="true"

# Colors
autoload -Uz colors && colors

# Disable annoying default behaviour of flow control bound to 'C-s' in zsh
stty -ixon

# ─────────────────────────────────────────────
# COMPLETIONS & EXTERNAL TOOL INTEGRATION
# ─────────────────────────────────────────────
# Load completions to fzf-menu
[[ $commands[docker] ]] && source <(docker completion zsh)
#[[ $commands[kubectl] ]] && source <(kubectl completion zsh)         # already loaded
#[[ $commands[go-task] ]] && source <(go-task --completion zsh)       # already loaded
[[ -f /opt/google-cloud-cli/path.zsh.inc ]] && source /opt/google-cloud-cli/path.zsh.inc
[[ -f /opt/google-cloud-cli/completion.zsh.inc ]] && source /opt/google-cloud-cli/completion.zsh.inc

# ─────────────────────────────────────────────
# PROFILING
# ─────────────────────────────────────────────
zmodload zsh/zprof

# ─────────────────────────────────────────────
# PLUGIN MANAGER & LOCAL FILES
# ─────────────────────────────────────────────
source "$ZDOTDIR/functions.zsh"

zsh_add_file "aliases.zsh"
zsh_add_file "scripts.zsh"
zsh_add_file "fzf-scripts.zsh"
zsh_add_file "completion.zsh"
zsh_add_file "bindings.zsh"
zsh_add_file "emacs-mode"

# ─────────────────────────────────────────────
# PLUGINS
# ─────────────────────────────────────────────
zsh_add_plugin "Aloxaf/fzf-tab"
zsh_add_plugin "Twilight4/nobility"
zsh_add_plugin "b4b4r07/enhancd"
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
zsh_add_plugin "hlissner/zsh-autopair"
#zsh_add_plugin "mrjohannchang/zsh-interactive-cd"
#zsh_add_completion "zsh-users/zsh-completions"

source "$ZDOTDIR/plugins/fg-bg.sh"
source "$ZDOTDIR/plugins/enhancd/init.sh"
zle -N fg-bg
bindkey '^Z' fg-bg

# ─────────────────────────────────────────────
# GENERAL OPTIONS & ENVIRONMENT
# ─────────────────────────────────────────────
WORDCHARS=${WORDCHARS//\/}
KEYTIMEOUT=1
PROMPT_EOL_MARK=""
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'
VIRTUAL_ENV_DISABLE_PROMPT=1

# ─────────────────────────────────────────────
# PROMPT
# ─────────────────────────────────────────────
PROMPT_TWOLINE=$'%F{%(#.red.blue)}┌──${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))─}(%B%F{%(#.blue.red)}%n@%m%b%F{%(#.red.blue)})-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{%(#.red.blue)}]\n└─%B%F{red}%(#.#.$)%b%F{reset} '
PROMPT_ONELINE=$'${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%B%F{%(#.red.blue)}%n@%m%b%F{reset}:%B%F{%(#.blue.green)}%~%b%F{reset}%(#.#.$) '

PROMPT="$PROMPT_TWOLINE"
PROMPT_STYLE=twoline

toggle_prompt_style() {
    if [[ "$PROMPT_STYLE" == twoline ]]; then
        PROMPT="$PROMPT_ONELINE"
        PROMPT_STYLE=oneline
    else
        PROMPT="$PROMPT_TWOLINE"
        PROMPT_STYLE=twoline
    fi
    zle reset-prompt
}
zle -N toggle_prompt_style
bindkey '^[|' toggle_prompt_style

# ─────────────────────────────────────────────
# SYNTAX HIGHLIGHTING
# ─────────────────────────────────────────────
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets cursor pattern)
ZSH_HIGHLIGHT_STYLES[path]=bold
ZSH_HIGHLIGHT_STYLES[path_prefix]=fg=white,underline
ZSH_HIGHLIGHT_STYLES[cursor]=standout
ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan,bold
ZSH_HIGHLIGHT_STYLES[arg0]=fg=cyan
ZSH_HIGHLIGHT_STYLES[precommand]=fg=green
ZSH_HIGHLIGHT_STYLES[alias]=fg=green,bold
ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,underline
ZSH_HIGHLIGHT_STYLES[global-alias]=fg=green,bold
ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=blue,underline
ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold
ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=blue,bold
ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue,bold
ZSH_HIGHLIGHT_STYLES[command-substitution]=none
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]=fg=magenta,bold
ZSH_HIGHLIGHT_STYLES[process-substitution]=none
ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]=fg=magenta,bold
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=green
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=green
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=yellow
ZSH_HIGHLIGHT_STYLES[rc-quote]=fg=magenta
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=magenta,bold
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=magenta,bold
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=magenta,bold
ZSH_HIGHLIGHT_STYLES[assign]=fg=blue,bold
ZSH_HIGHLIGHT_STYLES[redirection]=fg=blue,bold
ZSH_HIGHLIGHT_STYLES[comment]=fg=black,bold
ZSH_HIGHLIGHT_STYLES[named-fd]=none
ZSH_HIGHLIGHT_STYLES[numeric-fd]=none
ZSH_HIGHLIGHT_STYLES[bracket-error]=fg=red,bold
ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg=blue,bold
ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg=green,bold
ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg=magenta,bold
ZSH_HIGHLIGHT_STYLES[bracket-level-4]=fg=yellow,bold
ZSH_HIGHLIGHT_STYLES[bracket-level-5]=fg=cyan,bold
ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]=standout

# ─────────────────────────────────────────────
# COLORS & LS
# ─────────────────────────────────────────────
# Don't touch, must be everything in one if statement
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    export LS_COLORS="$LS_COLORS:ow=30;44:"

    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
    zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
fi

# ─────────────────────────────────────────────
# ADDITIONAL PLUGINS (SYSTEM-INSTALLED)
# ─────────────────────────────────────────────
if [ -f /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh ] || [ -f /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh ]; then
    if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
        \. /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
    else
        \. /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
    fi
fi

if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] || [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
        \. /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    else
        \. /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    fi
fi

# ─────────────────────────────────────────────
# COMMAND NOT FOUND HANDLERS
# ─────────────────────────────────────────────
if [ -f /etc/zsh_command_not_found ] || [ -f /usr/share/doc/pkgfile/command-not-found.zsh ]; then
  if [ -f /etc/zsh_command_not_found ]; then
    \. /etc/zsh_command_not_found
  else
    \. /usr/share/doc/pkgfile/command-not-found.zsh
  fi
fi

[[ -e /usr/share/doc/find-the-command/ftc.zsh ]] && source /usr/share/doc/find-the-command/ftc.zsh

# ─────────────────────────────────────────────
# TOOL INIT (ZOXIDE, FASD, THEFUCK, FZF)
# ─────────────────────────────────────────────
eval $(thefuck --alias)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(zoxide init zsh)"
eval "$(fasd --init auto)"

# ─────────────────────────────────────────────
# NOBILITY
# ─────────────────────────────────────────────
if [ -d ~/.config/zsh/plugins/nobility ]; then
    nb-vars-load &>/dev/null
fi
