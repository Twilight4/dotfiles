#!/usr/bin/env bash
# Sourced by install.sh, BEFORE prompt-reboot.sh — reports packages that the
# pre-flight check found missing from the repos/AUR and offers a retry while
# the user is still at the keyboard (prompt-reboot ends the session).

if [[ -s $FAILED_PACKAGES_FILE ]]; then
    echo
    err "Some packages were not found in the repos/AUR (renamed or removed upstream):"
    sed 's/^/  - /' "$FAILED_PACKAGES_FILE"
    warn "Full list saved to: $FAILED_PACKAGES_FILE"
    echo
    read -rp "Attempt to install them again? (y/n): " retry
    if [[ $retry == "y" ]]; then
        mapfile -t failed_pkgs < "$FAILED_PACKAGES_FILE"
        if paru --noconfirm -S "${failed_pkgs[@]}"; then
            ok "Retry succeeded."
            : > "$FAILED_PACKAGES_FILE"
        else
            err "Retry failed — the list stays in $FAILED_PACKAGES_FILE for manual resolution."
        fi
    fi
fi
