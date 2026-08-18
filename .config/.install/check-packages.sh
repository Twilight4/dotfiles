#!/usr/bin/env bash
# CI helper (weekly GitHub Action, also runnable locally): verify that every
# package name in install-hypr-packages.sh still exists in the Arch repos or
# the AUR. Exits 1 and lists the rotten names if any are gone.
#
# Uses the AUR RPC API instead of building paru — keeps the CI container
# minimal. Not sourced by install.sh; standalone.
set -uo pipefail

LIST_FILE="${1:-$(dirname "$(realpath "$0")")/install-hypr-packages.sh}"

# Extract quoted names between 'name=(' and the closing ')'
extract_array() {
    sed -n "/^$1=(/,/^)/p" "$LIST_FILE" | grep -oP '(?<=")[^"]+'
}

missing=()
check() {
    local pkg="$1" group="$2"
    # Repo package?
    pacman -Si "$pkg" &>/dev/null && return 0
    # AUR package?
    curl -sf "https://aur.archlinux.org/rpc/?v=5&type=info&arg=$pkg" \
        | grep -q '"resultcount":1' && return 0
    missing+=("$group: $pkg")
}

for group in bloat packages extra; do
    while IFS= read -r pkg; do
        check "$pkg" "$group"
    done < <(extract_array "$group")
done

if ((${#missing[@]})); then
    printf 'MISSING PACKAGES (%d):\n' "${#missing[@]}"
    printf '  %s\n' "${missing[@]}"
    exit 1
fi
echo "All package names in $(basename "$LIST_FILE") still exist."
