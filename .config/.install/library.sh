#!/usr/bin/env bash
# Shared helpers for the .install modules. Sourced by install.sh — never run
# directly. Modules inherit `set -euo pipefail` from install.sh, so helpers
# signal failure via exit codes, not `exit`.

#-------------------------------------------------------------------- logging
# Plain ANSI; respects NO_COLOR (https://no-color.org). No logging framework —
# these run once, interactively, from a TTY.
if [[ -z "${NO_COLOR:-}" ]]; then
    _C_INFO=$'\033[34m' _C_OK=$'\033[32m' _C_WARN=$'\033[33m' _C_ERR=$'\033[31m' _C_OFF=$'\033[0m'
else
    _C_INFO='' _C_OK='' _C_WARN='' _C_ERR='' _C_OFF=''
fi
info() { printf '%s:: %s%s\n' "$_C_INFO" "$*" "$_C_OFF"; }
ok()   { printf '%s:: %s%s\n' "$_C_OK" "$*" "$_C_OFF"; }
warn() { printf '%sWARN: %s%s\n' "$_C_WARN" "$*" "$_C_OFF"; }
err()  { printf '%sERROR: %s%s\n' "$_C_ERR" "$*" "$_C_OFF" >&2; }

#--------------------------------------------------------- package detection
# Exit-code based: `pacman -Qq` is locale- and color-proof, unlike grep on
# `pacman -Qs` output. Query needs no sudo.
_isInstalledPacman() { pacman -Qq "$1" &>/dev/null; }
_isInstalledParu()   { paru   -Qq "$1" &>/dev/null; }

# Names that don't exist in the repos/AUR are appended here (one per line)
# instead of killing the batch; install.sh offers a retry at the end.
# Set and truncated by install.sh before sourcing modules.
: "${FAILED_PACKAGES_FILE:=$HOME/.cache/dotfiles-failed-packages.txt}"

# Keep only names that actually exist; record the rotten ones.
# $1: "pacman"|"paru"; rest: package names. Prints the valid ones.
_filterAvailable() {
    local backend="$1" pkg
    shift
    for pkg in "$@"; do
        if [[ $backend == pacman ]]; then
            pacman -Si "$pkg" &>/dev/null || { printf '%s\n' "$pkg" >> "$FAILED_PACKAGES_FILE"; continue; }
        else
            # paru -Si covers repos AND the AUR
            paru -Si "$pkg" &>/dev/null || { printf '%s\n' "$pkg" >> "$FAILED_PACKAGES_FILE"; continue; }
        fi
        printf '%s\n' "$pkg"
    done
}

#--------------------------------------------------------- package install
# Both install functions dedup their arguments: the package arrays in
# install-hypr-packages.sh historically accumulated duplicates, and each dup
# costs a repo query.
_installPackagesPacman() {
    local -A seen=()
    local -a toInstall=()
    local pkg
    for pkg in "$@"; do
        [[ -n ${seen[$pkg]:-} ]] && continue
        seen[$pkg]=1
        if _isInstalledPacman "$pkg"; then
            info "$pkg is already installed."
            continue
        fi
        toInstall+=("$pkg")
    done

    ((${#toInstall[@]})) || return 0
    mapfile -t toInstall < <(_filterAvailable pacman "${toInstall[@]}")
    ((${#toInstall[@]})) || { warn "Nothing left to install (see $FAILED_PACKAGES_FILE)."; return 0; }
    sudo pacman --noconfirm -S "${toInstall[@]}"
}

_installPackagesParu() {
    local -A seen=()
    local -a toInstall=()
    local pkg
    for pkg in "$@"; do
        [[ -n ${seen[$pkg]:-} ]] && continue
        seen[$pkg]=1
        if _isInstalledParu "$pkg"; then
            info "$pkg is already installed."
            continue
        fi
        toInstall+=("$pkg")
    done

    ((${#toInstall[@]})) || return 0
    mapfile -t toInstall < <(_filterAvailable paru "${toInstall[@]}")
    ((${#toInstall[@]})) || { warn "Nothing left to install (see $FAILED_PACKAGES_FILE)."; return 0; }
    # paru self-escalates for the pacman step — never prefix with sudo.
    paru --noconfirm -S "${toInstall[@]}"
}

#------------------------------------------------------- package uninstall
_uninstallPackagesParu() {
    local -A seen=()
    local -a toUninstall=()
    local pkg
    for pkg in "$@"; do
        [[ -n ${seen[$pkg]:-} ]] && continue
        seen[$pkg]=1
        if ! _isInstalledParu "$pkg"; then
            info "$pkg is not installed."
            continue
        fi
        toUninstall+=("$pkg")
    done

    ((${#toUninstall[@]})) || return 0
    paru --noconfirm -Rns "${toUninstall[@]}"
}
