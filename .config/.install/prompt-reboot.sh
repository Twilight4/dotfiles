#!/usr/bin/env bash
# Sourced by install.sh — use `return`, not `exit`.

clear
cat <<"EOF"
 ____   ___  _   _ _____   _
|  _ \ / _ \| \ | | ____| | |
| | | | | | |  \| |  _|   | |
| |_| | |_| | |\  | |___  |_|
|____/ \___/|_| \_|_____  (_)

EOF

# Clean up the cloned repo. Safe because install-dotfiles.sh deploys by
# copying — ~/.config holds real files, nothing points back into the repo.
if [[ -d ${DOTFILES_DIR:-$HOME/dotfiles} ]]; then
    cd "$HOME" || return 1
    info "Cleaning up dotfiles directory..."
    rm -rf "$DOTFILES_DIR"
    ok "Dotfiles directory cleaned up."
fi

# Instructions for a user
echo ""
ok "Installation Finished."
echo "To complete the setup, launch Hyprland, exit Hyprland and log in again."
echo ""
echo "You can run Hyprland by typing:"
echo "  Hyprland"
echo ""
