#!/usr/bin/env bash
# Sourced by install.sh — use `return`, not `exit`. Expects DOTFILES_DIR.

clear
cat <<"EOF"
 ____        _    __ _ _
|  _ \  ___ | |_ / _(_) | ___  ___
| | | |/ _ \| __| |_| | |/ _ \/ __|
| |_| | (_) | |_|  _| | |  __/\__ \
|____/ \___/ \__|_| |_|_|\___||___/

EOF

# Prompt the user
read -rp "This will install all dotfiles configurations. Press any key to continue or Ctrl+C to exit..." -n 1 -s
echo

# Exported so prompt-reboot.sh knows whether deleting the cloned repo is safe.
INSTALL_METHOD=""
export INSTALL_METHOD

# Install dotfiles as symlinks: ~/.config/<app> -> $DOTFILES_DIR/.config/<app>
install_symlinks() {
    info "Installing dotfiles using symlinks..."
    local app
    for app in kitty btop cava cheat emacs fontconfig foot fortune git gtklock \
               lsd mpd mpv newsboat npm pipewire.conf.d wal zathura zsh \
               rofi swaync hypr waybar swaylock wlogout swappy; do
        _installSymLink "$app" "$HOME/.config/$app" "$DOTFILES_DIR/.config/$app/" "$HOME/.config"
    done
    # Single files and dirs nested one level deeper
    _installSymLink user-dirs.dirs "$HOME/.config/user-dirs.dirs" "$DOTFILES_DIR/.config/user-dirs.dirs" "$HOME/.config"
    _installSymLink gtk-3.0 "$HOME/.config/gtk-3.0" "$DOTFILES_DIR/.config/gtk-3.0/" "$HOME/.config/"
    _installSymLink gtk-4.0 "$HOME/.config/gtk-4.0" "$DOTFILES_DIR/.config/gtk-4.0/" "$HOME/.config/"
    INSTALL_METHOD=symlinks
}

# Install dotfiles by copying the whole .config over the live one
install_by_copy() {
    info "Copying files to ~/.config..."
    # Deliberate rm: clean-slate deploy, no merge with pre-existing configs.
    rm -rf "$HOME/.config/"
    cp -r "$DOTFILES_DIR/.config" "$HOME/"
    ok "Files copied successfully."
    INSTALL_METHOD=copy
}

main() {
    echo "Choose installation method:"
    echo "1. Use symlinks"
    echo "2. Copy dotfiles to ~/.config"
    echo "3. Skip installation"

    local choice
    read -rp "Enter your choice: " choice

    case $choice in
        1) install_symlinks ;;
        2) install_by_copy ;;
        3) info "Skipping installation..." ;;
        *) warn "Invalid choice. Please enter a number between 1 and 3." ;;
    esac

    # Copy the emacs AI prompts
    local source_dir="$DOTFILES_DIR/.config/ai-prompts"
    local dest_dir="$HOME/.cache/emacs"

    if [[ -d $source_dir ]]; then
        info "Copying AI prompts from $source_dir to $dest_dir..."
        cp -r "$source_dir" "$dest_dir"
        ok "Copy completed successfully."
    else
        warn "Source directory $source_dir does not exist."
    fi

    # Setting mime type for org mode (org mode is not recognised as its own mime type by default)
    update-mime-database "$HOME/.config/.local/share/mime"
    xdg-mime default emacs.desktop text/org

    # Update dirs
    xdg-user-dirs-update
}

main
