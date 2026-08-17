#!/usr/bin/env bash
# Sourced by install.sh — use `return`, not `exit`.

clear
cat <<"EOF"
 _____ __________
|  ___|__  /  ___|
| |_    / /| |_
|  _|  / /_|  _|
|_|   /____|_|

EOF

# Prompt the user
read -p "This will install FZF and atuin. Press any key to continue or Ctrl+C to exit..." -n 1 -s
echo

# fzf: clone fresh, or update in place on re-run
if [[ -d $HOME/.fzf/.git ]]; then
    info "~/.fzf already exists. Updating..."
    git -C "$HOME/.fzf" pull --ff-only
    "$HOME/.fzf/install"
elif [[ -e $HOME/.fzf ]]; then
    warn "~/.fzf exists but is not a git checkout. Skipping fzf."
else
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    "$HOME/.fzf/install"
    ok "FZF installed successfully."
fi

# atuin: skip when already installed
if command -v atuin >/dev/null; then
    info "atuin is already installed. Skipping..."
else
    curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
fi
