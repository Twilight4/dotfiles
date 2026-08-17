#!/usr/bin/env bash
# Sourced by install.sh — use `return`, not `exit`. Expects DOTFILES_DIR.

clear
cat <<"EOF"
 _   ___     ______ _               _
| \ | \ \   / / ___| |__   __ _  __| |
|  \| |\ \ / / |   | '_ \ / _` |/ _` |
| |\  | \ V /| |___| | | | (_| | (_| |
|_| \_|  \_/  \____|_| |_|\__,_|\__,_|

EOF

# Prompt the user
read -rp "This will install NVChad configuration. Press any key to continue or Ctrl+C to exit..." -n 1 -s
echo

# Clean-slate reinstall: remove any existing config/state so the starter
# clone always lands on a fresh tree (safe to re-run).
if [[ -d $HOME/.config/nvim ]]; then
    echo
    rm -rf "$HOME/.config/nvim" \
           "$HOME/.local/state/nvim" \
           "$HOME/.local/share/nvim"
    info "Existing NVChad configuration removed."
fi

# Clone the NVChad starter
if git clone https://github.com/NvChad/starter "$HOME/.config/nvim"; then
    ok "NVChad configuration cloned successfully."

    # Set background color to the same as in kitty and emacs
    echo -e "\n-- Disable the status line\nvim.opt.laststatus = 0\n\n-- set background color to #040305\nvim.cmd(\"highlight Normal guibg=#040305 ctermbg=black\")" >> "$HOME/.config/nvim/init.lua"
else
    err "Failed to clone NVChad repository."
    return 1
fi

# Copy custom lua file
if cp "$DOTFILES_DIR/.config/nvim/lua/kitty+page.lua" "$HOME/.config/nvim/lua"; then
    echo
    ok "Custom lua file copied successfully."
else
    err "Custom lua file not found in $DOTFILES_DIR."
    return 1
fi

echo
ok "NVChad configuration installation complete."
