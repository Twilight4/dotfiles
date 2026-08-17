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

# Clean up the cloned repo — but ONLY when dotfiles were deployed by copying.
# With symlink deploy (INSTALL_METHOD=symlinks), every config in ~/.config
# points INTO this repo: deleting it would break the entire configuration.
if [[ ${INSTALL_METHOD:-} == "copy" && -d ${DOTFILES_DIR:-$HOME/dotfiles} ]]; then
    cd "$HOME"
    echo "Cleaning up dotfiles directory..."
    rm -rf "$DOTFILES_DIR"
    echo "Dotfiles directory cleaned up."
elif [[ ${INSTALL_METHOD:-} == "symlinks" ]]; then
    echo "Keeping $DOTFILES_DIR: ~/.config symlinks point into it."
fi

# Instructions for a user
echo ""
echo "Installation Finished."
echo "To complete the setup, launch Hyprland, exit Hyprland and log in again."
echo ""
echo "You can run Hyprland by typing:"
echo "  Hyprland"
echo ""
