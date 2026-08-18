#!/usr/bin/env bash
# Sourced by install.sh — use `return`, not `exit`.

# Refuse to run when the repo was cloned into the live config dir: the deploy
# step would then operate on its own target. `mode=dev` bypasses for testing.
SCRIPTPATH=$(dirname "$(realpath "$0")")
if [[ $SCRIPTPATH == "/home/$USER/.config" && ${mode:-} != "dev" ]]; then
    err "IMPORTANT: You're running the installation script from the installation target directory."
    warn "Please move the dotfiles repository to i.e. ~/downloads/ and start the script again."
    echo ""
    return 1
fi

while true; do
    read -rp "START THE INSTALLATION? (y/n): " yn
    case $yn in
        [Yy]*) ok "Installation started."; break ;;
        [Nn]*) warn "Installation canceled."; return 1 ;;
        *)     warn "Please answer yes or no." ;;
    esac
done
echo ""
