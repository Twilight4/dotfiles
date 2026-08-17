#!/usr/bin/env bash
# Sourced by install.sh — use `return`, not `exit`.

clear
cat <<"EOF"
 _____           _
|  ___|__  _ __ | |_ ___
| |_ / _ \| '_ \| __/ __|
|  _| (_) | | | | |_\__ \
|_|  \___/|_| |_|\__|___/

EOF

# Prompt the user
read -rp "This will install fonts. Press any key to continue or Ctrl+C to exit..." -n 1 -s
echo

FONT_DIR="$HOME/.config/.local/share/fonts"

# Download and install one Nerd Font release tarball.
# Fails HARD (return 1 -> set -e aborts) when the download is exhausted or the
# tarball is bad — the previous version silently continued past a failed
# download and tar'd a missing file, which is why Meslo ended up uninstalled
# while the script reported success.
install_nerd_font() {
    local name="$1" url="$2"
    local dest="$FONT_DIR/$name"
    local tarball
    tarball=$(mktemp --suffix=.tar.xz)

    info "Downloading $name Nerd Font..."
    # -f: fail on HTTP errors; --retry: transient network resilience.
    if ! curl -fL --retry 3 --retry-delay 2 -o "$tarball" "$url"; then
        err "Download failed: $url"
        rm -f "$tarball"
        return 1
    fi
    # Guard against an empty/truncated download before touching the font dir.
    if [[ ! -s $tarball ]] || ! tar -tJf "$tarball" &>/dev/null; then
        err "Corrupt tarball for $name."
        rm -f "$tarball"
        return 1
    fi

    # Deliberate rm: stale glyphs of the same family should not linger.
    rm -rf "$dest"
    mkdir -p "$dest"
    tar -xJf "$tarball" -C "$dest"
    rm -f "$tarball"

    # Verify the extract actually produced font files.
    if ! find "$dest" -name '*.ttf' -print -quit | grep -q .; then
        err "No .ttf files found in $dest after extraction."
        return 1
    fi
    ok "$name installed."
}

install_nerd_font "JetBrainsMono" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"
install_nerd_font "Meslo"         "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.tar.xz"

# Rebuild the cache so the new fonts are immediately visible.
fc-cache -f >/dev/null

echo
ok "Fonts installed successfully."
