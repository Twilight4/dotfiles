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

# Copy the whole .config over the live one.
# Deliberate rm: clean-slate deploy, no merge with pre-existing configs.
info "Copying files to ~/.config..."
rm -rf "$HOME/.config/"
cp -r "$DOTFILES_DIR/.config" "$HOME/"
ok "Files copied successfully."

# Copy the emacs AI prompts
source_dir="$DOTFILES_DIR/.config/ai-prompts"
dest_dir="$HOME/.cache/emacs"

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
