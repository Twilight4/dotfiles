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
echo "Installation Finished."
echo "To complete the setup, reboot and log in via SDDM (enabled by the installer)."
echo ""
echo "To start Hyprland from a TTY instead, use the uwsm-managed entry:"
echo "  uwsm start garuda-hyprland-uwsm.desktop"
echo ""
echo "Once inside the desktop session, you can run the post-install workflow:"
echo "  ~/.config/.install/post-install.sh"
echo ""
echo "It walks through the remaining bootstrap steps (hyprpm plugins, cloud"
echo "sync, app theming, AI tooling, docker MCP, ...) with per-step prompts."
echo "NOTE: it is tailored to Twilight4's personal apps and preferences —"
echo "skip or edit steps that don't apply to you."
echo ""
