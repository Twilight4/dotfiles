#!/usr/bin/env bash
# Sourced by install.sh — runs FIRST after confirm-start: NOPASSWD up front
# means the remaining ~30 min of modules never stop for a password prompt.

clear
cat <<"EOF"
 ____            _                     _
/ ___| _   _  __| | ___   ___ _ __ ___| |
\___ \| | | |/ _` |/ _ \ / _ \ '__/ __| |
 ___) | |_| | (_| | (_) |  __/ |  \__ \_|
|____/ \__,_|\__,_|\___/ \___|_|  |___(_)

EOF

#------------------------------------------------------------------ sudoers
read -rp "Add $USER to sudoers with NOPASSWD and disable /etc/sudoers.d drop-ins? (y/n) " add_sudoer
if [[ $add_sudoer == "y" ]]; then
    sudoers_line="$USER ALL=(ALL:ALL) NOPASSWD: ALL"

    if sudo grep -qF "$sudoers_line" /etc/sudoers; then
        info "sudoers entry already present."
    else
        # Never write /etc/sudoers directly: build a modified copy, validate
        # with visudo -cf, only then replace. A syntax error in sudoers
        # bricks sudo for the whole system.
        tmp=$(mktemp)
        # shellcheck disable=SC2024  # tmp is user-owned (mktemp); only the read needs sudo
        sudo cat /etc/sudoers > "$tmp"
        printf '%s\n' "$sudoers_line" >> "$tmp"
        sudo sed -i 's|^@includedir /etc/sudoers.d|#@includedir /etc/sudoers.d|' "$tmp"

        if sudo visudo -cf "$tmp" >/dev/null; then
            sudo cp "$tmp" /etc/sudoers
            sudo chmod 440 /etc/sudoers
            ok "sudoers updated: NOPASSWD for $USER, sudoers.d include commented out."
        else
            err "Modified sudoers failed validation — /etc/sudoers left untouched."
            rm -f "$tmp"
            return 1
        fi
        rm -f "$tmp"
    fi
fi

#------------------------------------------------------- snap-pac hooks
read -rp "Disable pacman snapshot hooks (snap-pac pre/post)? (y/n) " disable_hooks
if [[ $disable_hooks == "y" ]]; then
    hooks_dir=/usr/share/libalpm/hooks
    for hook in 05-snap-pac-pre.hook zz-snap-pac-post.hook; do
        if [[ -f $hooks_dir/$hook ]]; then
            sudo mv "$hooks_dir/$hook" "$hooks_dir/$hook.disabled"
            ok "Disabled $hook"
        elif [[ -f $hooks_dir/$hook.disabled ]]; then
            info "$hook already disabled."
        else
            warn "$hook not found (snap-pac not installed?)."
        fi
    done
    info "Re-enable with: sudo mv $hooks_dir/<hook>.disabled $hooks_dir/<hook>"
fi
