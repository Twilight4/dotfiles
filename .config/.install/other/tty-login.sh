#!/usr/bin/env bash
# Standalone script (not sourced by install.sh).
set -euo pipefail

clear
# Opt-in: export disman=1 before running (nothing in the repo sets it).
if [[ ${disman:-0} == 1 ]]; then
    cat <<"EOF"
 _____ _______   __  _             _
|_   _|_   _\ \ / / | | ___   __ _(_)_ __
  | |   | |  \ V /  | |/ _ \ / _` | | '_ \
  | |   | |   | |   | | (_) | (_| | | | | |
  |_|   |_|   |_|   |_|\___/ \__, |_|_| |_|
                             |___/

EOF
    while true; do
        echo
        read -rp "Do you want to install the custom tty login issue (Yy/Nn): " yn
        case $yn in
            [Yy]*)
                curl -fLJO https://raw.githubusercontent.com/Twilight4/dotfiles/main/.config/login/issue \
                    && sudo mv issue /etc/issue
                break
                ;;
            [Nn]*)
                printf "\033[33m%s\033[0m\n" "Setup tty login skipped."
                break
                ;;
            *) printf "\033[33m%s\033[0m\n" "Please answer yes or no." ;;
        esac
    done
    echo ""
fi
