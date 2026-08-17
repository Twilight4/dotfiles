#!/usr/bin/env bash
# Sourced by install.sh — use `return`, not `exit`.
# Runs only when disman=1 is exported before install.sh (nothing in the repo
# sets it; opt-in for machines that need SDDM configured).

if [[ ${disman:-0} == 1 ]]; then
    cat <<"EOF"
____  _           _               __  __
|  _ \(_)___ _ __ | | __ _ _   _  |  \/  | __ _ _ __   __ _  __ _  ___ _ __
| | | | / __| '_ \| |/ _` | | | | | |\/| |/ _` | '_ \ / _` |/ _` |/ _ \ '__|
| |_| | \__ \ |_) | | (_| | |_| | | |  | | (_| | | | | (_| | (_| |  __/ |
|____/|_|___/ .__/|_|\__,_|\__, | |_|  |_|\__,_|_| |_|\__,_|\__, |\___|_|
            |_|            |___/                            |___/

EOF

    # Prompt the user
    read -p "This will configure SDDM display manager. Press any key to continue or Ctrl+C to exit..." -n 1 -s
    echo

    info "Creating /etc/sddm.conf file..."
    # Timestamped backup of any existing config; missing file is fine.
    if [[ -f /etc/sddm.conf ]]; then
        sudo cp /etc/sddm.conf "/etc/sddm.conf.bak.$(date +%s)"
    fi

    # Clone the sddm.conf config file
    curl -fLJO https://raw.githubusercontent.com/Twilight4/dotfiles/main/.config/sddm/sddm.conf && sudo mv sddm.conf /etc/sddm.conf

    # Download the avatar image
    curl -fLJO https://raw.githubusercontent.com/Twilight4/dotfiles/refs/heads/main/.config/sddm/avatar.jpg && sudo mv avatar.jpg /usr/share/sddm/themes/pixie/assets/avatar.jpg

    # Clone the theme.conf config file
    curl -fLJO https://raw.githubusercontent.com/Twilight4/dotfiles/main/.config/sddm/theme.conf && sudo mv theme.conf /usr/share/sddm/themes/pixie/theme.conf

    # Clone the Main.qml config file
    curl -fLJO https://raw.githubusercontent.com/Twilight4/dotfiles/main/.config/sddm/Main.qml && sudo mv Main.qml /usr/share/sddm/themes/pixie/Main.qml

    # Keep only the uwsm Hyprland session; disable the bloat ones.
    # Guarded: re-runs (or already-disabled sessions) must not abort.
    session_dir=/usr/share/wayland-sessions
    for f in garuda-hyprland hyprland hyprland-uwsm; do
        if [[ -f $session_dir/$f.desktop ]]; then
            sudo mv "$session_dir/$f.desktop" "$session_dir/$f.desktop.disabled"
        fi
    done
    sudo sed -i 's/^Name=.*/Name=Hyprland/' "$session_dir/garuda-hyprland-uwsm.desktop"

    # Greeter keyboard: match Hyprland layout and remap CapsLock to Ctrl so it can't
    # silently toggle on in SDDM (writes /etc/X11/xorg.conf.d/00-keyboard.conf)
    sudo localectl set-x11-keymap pl "" "" ctrl:nocaps

    ok "/etc/sddm.conf file created."
fi
