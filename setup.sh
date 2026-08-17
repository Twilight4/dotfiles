#!/usr/bin/env bash
# Online bootstrap for the dotfiles installation, run from a TTY on a fresh
# Arch(-based) install:
#   curl -L <raw-url>/setup.sh | bash
# or with a custom clone path:
#   bash setup.sh ~/downloads/dotfiles
set -euo pipefail

me="-->online-setup<--"
remote_repo=Twilight4/dotfiles

# Run a command; on failure offer an interactive retry/abort instead of
# dying to set -e, so transient network errors don't kill the bootstrap.
x() {
    until "$@"; do
        printf '\e[31m%s: Command "\e[32m%s\e[31m" has failed.\n' "$me" "$*"
        printf 'Resolve the problem manually BEFORE repeating.\e[0m\n'
        printf '  r = repeat this command (default)\n  e = exit now\n'
        read -rp " [R/e]: " p
        case $p in
            [eE]) printf '\e[34mExiting.\e[0m\n'; exit 1 ;;
            *)    printf '\e[34mOK, repeating...\e[0m\n' ;;
        esac
    done
    printf '\e[34m%s: Command "\e[32m%s\e[34m" finished.\e[0m\n' "$me" "$*"
}

command -v pacman >/dev/null \
    || { echo '"pacman" not found. This script only works on Arch(-based) distros. Aborting...'; exit 1; }

path=${1:-$HOME/dotfiles}
# Absolute path + exported: install.sh and the modules it sources deploy
# FROM this directory, so they must agree on where the repo lives.
DOTFILES_DIR=$(realpath -m "$path")
export DOTFILES_DIR

echo "$me: Downloading repo to $DOTFILES_DIR ..."
x mkdir -p "$DOTFILES_DIR"
cd "$DOTFILES_DIR"
if [[ -z "$(ls -A)" ]]; then
    x git init -b main
    x git remote add origin "https://github.com/$remote_repo"
fi
git remote get-url origin | grep -q "$remote_repo" \
    || { echo "Dir \"$DOTFILES_DIR\" is not empty, nor a git repo of $remote_repo. Aborting..."; exit 1; }
x git pull origin main && git submodule update --init --recursive
echo "$me: Downloaded."

echo "$me: Running \"install.sh\"."
x .config/.install/install.sh || { echo "$me: Error occurred when running \"install.sh\"."; exit 1; }
