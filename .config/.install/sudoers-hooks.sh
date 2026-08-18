#!/usr/bin/env bash
# Sourced by install.sh — runs FIRST after confirm-start: NOPASSWD up front
# means the remaining ~30 min of modules never stop for a password prompt.
# Each phase is a single `sudo` call, so this module costs ONE password
# prompt at most (and install.sh already primed the cache with sudo -v).

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
        # Payload holds the line to append; the whole edit runs as ONE sudo
        # call: build a modified copy, validate with visudo -cf, only then
        # replace. A syntax error in sudoers bricks sudo — never write it
        # unvalidated.
        payload=$(mktemp)
        printf '%s\n' "$sudoers_line" > "$payload"

        if sudo bash -c '
            set -e
            tmp=$(mktemp)
            cat /etc/sudoers > "$tmp"
            cat "$1" >> "$tmp"
            sed -i "s|^@includedir /etc/sudoers.d|#@includedir /etc/sudoers.d|" "$tmp"
            if visudo -cf "$tmp" >/dev/null; then
                cp "$tmp" /etc/sudoers
                chmod 440 /etc/sudoers
            else
                exit 1
            fi
            rm -f "$tmp"
        ' _ "$payload"; then
            ok "sudoers updated: NOPASSWD for $USER, sudoers.d include commented out."
        else
            err "Modified sudoers failed validation — /etc/sudoers left untouched."
            rm -f "$payload"
            return 1
        fi
        rm -f "$payload"
    fi
fi

#------------------------------------------------------- snap-pac hooks
read -rp "Disable pacman snapshot hooks (snap-pac pre/post)? (y/n) " disable_hooks
if [[ $disable_hooks == "y" ]]; then
    hooks_dir=/usr/share/libalpm/hooks
    # One sudo call for all renames; guards make re-runs safe.
    sudo bash -c '
        set -e
        dir=/usr/share/libalpm/hooks
        for hook in 05-snap-pac-pre.hook zz-snap-pac-post.hook; do
            [[ -f $dir/$hook ]] && mv "$dir/$hook" "$dir/$hook.disabled" || true
        done
    '
    for hook in 05-snap-pac-pre.hook zz-snap-pac-post.hook; do
        if [[ -f $hooks_dir/$hook.disabled ]]; then
            ok "Disabled $hook"
        else
            warn "$hook not found (snap-pac not installed?)."
        fi
    done
    info "Re-enable with: sudo mv $hooks_dir/<hook>.disabled $hooks_dir/<hook>"
fi
