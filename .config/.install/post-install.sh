#!/usr/bin/env bash
# Post-installation workflow — run AFTER install.sh, inside the desktop
# session (some steps need a running Hyprland). Standalone, not sourced.
#
# Every step shows what it does first, then:
#   [Enter] = run/done   s = skip   q = quit
# Re-running is safe: automated steps are idempotent, skipped/failed steps
# can simply be retried by running the script again.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$(realpath "$0")")" && pwd)"
# shellcheck source=library.sh
source "$SCRIPT_DIR/library.sh"

STEP=0
TOTAL=15

#------------------------------------------------------------- flow helpers
# banner <title> — step header
banner() {
    STEP=$((STEP + 1))
    echo
    printf '%s────────────────────────────────────────────%s\n' "$_C_INFO" "$_C_OFF"
    printf '%s[%d/%d] %s%s\n' "$_C_INFO" "$STEP" "$TOTAL" "$*" "$_C_OFF"
    printf '%s────────────────────────────────────────────%s\n' "$_C_INFO" "$_C_OFF"
}

# confirm_run — returns 0 to run, 1 to skip, exits on quit
confirm_run() {
    local ans
    read -rp "[Enter]=run  s=skip  q=quit: " ans
    case $ans in
        [qQ]*) info "Quit at step $STEP/$TOTAL."; exit 0 ;;
        [sS]*) warn "Skipped."; return 1 ;;
        *)     return 0 ;;
    esac
}

# manual <instructions...> — boxed manual step; user confirms completion
manual() {
    echo
    printf '%sMANUAL STEP:%s\n' "$_C_WARN" "$_C_OFF"
    printf '  %s\n' "$@"
    echo
    read -rp "Press Enter when done (or s to skip): " ans
    if [[ $ans == [sS]* ]]; then
        warn "Skipped."
    else
        ok "Done."
    fi
}

# run_or_fail <description> <cmd...> — run, report, never silently continue
run_or_fail() {
    local desc="$1"; shift
    if "$@"; then
        ok "$desc"
    else
        err "$desc — FAILED. Fix it and re-run this script."
        return 1
    fi
}

#================================================================ Steps ====

#-------------------------------------------------- 1. Hyprland plugins
banner "Hyprland plugins (hyprpm)"
echo "Installs + enables hyprexpo. Requires a RUNNING Hyprland session."
if [[ -z ${HYPRLAND_INSTANCE_SIGNATURE:-} ]]; then
    err "Hyprland is not running in this session."
    echo "Re-run this step later inside Hyprland with:"
    echo "  $SCRIPT_DIR/post-install.sh"
    manual "Log into Hyprland, then re-run this script (skip the steps already done)."
else
    if confirm_run; then
        run_or_fail "hyprpm update" hyprpm update
        run_or_fail "add hyprland-plugins" hyprpm add https://github.com/hyprwm/hyprland-plugins
        run_or_fail "add hyprexpo" hyprpm add https://github.com/sandwichfarm/hyprexpo
        run_or_fail "enable hyprexpo" hyprpm enable hyprexpo
        run_or_fail "hyprpm reload" hyprpm reload
    fi
fi

#--------------------------------------------------- 2. GNOME Keyring
banner "GNOME Keyring — empty password"
manual "The first time an app needs the keyring, a dialog appears." \
       "Just press Enter (empty password) to avoid secret-storage friction."

#----------------------------------------------------------- 3. Sync data
banner "Sync cloud data (ssh keys via Mega, GitHub repos)"
echo "Syncs ~/.ssh from Mega, pulls GitHub repos, applies small CLI fixes."
if confirm_run; then
    # megacmd
    if ! command -v mega-sync >/dev/null; then
        run_or_fail "install megacmd" paru -S --noconfirm megacmd
    fi

    # Mega login only if needed
    if ! mega-whoami &>/dev/null; then
        echo
        read -rp "Mega email: " mega_email
        read -rsp "Mega password: " mega_pass; echo
        run_or_fail "mega-login" mega-login "$mega_email" "$mega_pass"
        unset mega_pass
    else
        info "Already logged into Mega."
    fi

    # Only the ssh keys sync (rest of Mega sync is retired)
    run_or_fail "sync ~/.ssh" mega-sync /home/twilight/.ssh/ /SYNCED-DATA/.ssh/

    # GitHub repos
    run_or_fail "gh-sync" gh-sync

    # zsh-autopair: unbind C-h / ^? from autopair-delete (idempotent sed)
    autopair="$HOME/.config/zsh/plugins/zsh-autopair/autopair.zsh"
    if [[ -f $autopair ]]; then
        sed -i '/    bindkey "^?" autopair-delete/d' "$autopair"
        sed -i '/    bindkey "^h" autopair-delete/d' "$autopair"
        ok "zsh-autopair C-h bindings removed."
    else
        warn "$autopair not found — skipping."
    fi

    # bat theme cache
    run_or_fail "bat cache build" bat cache --build

    # Fonts sanity (Meslo was historically flaky; install-fonts is now strict)
    if [[ -d $HOME/.config/.local/share/fonts/Meslo ]]; then
        info "Fonts OK (Meslo present)."
    else
        warn "Meslo fonts missing — re-running install-fonts.sh..."
        DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
        bash "$SCRIPT_DIR/install-fonts.sh"
    fi

    # Remove Garuda default icons/themes (packages can't be uninstalled)
    for junk in /usr/share/icons/candy-icons /usr/share/icons/BeautyLine /usr/share/themes/Sweet-Dark; do
        if [[ -e $junk ]]; then
            sudo rm -rf "$junk"
            ok "Removed $junk"
        else
            info "$junk already absent."
        fi
    done
fi

#--------------------------------------------------- 4. Zen browser
banner "Zen browser setup (manual)"
manual "Create a profile named 'Default (release)'." \
       "Optional: zen-browser --ProfileManager → new profile 'YouTube'," \
       "  install ad-block, log in to YouTube (for the ws-zen-yt workspace)." \
       "Apply the config: https://github.com/Twilight4/zen-browser-config" \
       "Install the Proton Pass extension and log in to GitHub."

#---------------------------------------------- 5. Zen profiles.ini
banner "Zen profiles.ini — fix default profile"
echo "Edits ~/.zen/profiles.ini so xdg-open uses 'Default (release)':"
echo "  Default=1 under that profile, StartWithLastProfile=0."
profiles_ini="$HOME/.zen/profiles.ini"
if [[ ! -f $profiles_ini ]]; then
    warn "$profiles_ini not found — create the profiles first, then re-run."
elif confirm_run; then
    run_or_fail "StartWithLastProfile=0" \
        sed -i 's/^StartWithLastProfile=1/StartWithLastProfile=0/' "$profiles_ini"
    warn "Check that Default=1 sits under the 'Default (release)' profile section:"
    grep -n -B2 '^Default=1' "$profiles_ini" || true
fi

#------------------------------------------------------- 6. Dock pins
banner "nwg-dock-hyprland pins (manual)"
manual "Pin on the dock: Bluetooth, pavucontrol, gnome-clocks, kitty-2," \
       "  freetube, Netflix, zen browser, telegram, spotify, steam," \
       "  filemanager, protonmail, protonvpn, google maps, weather," \
       "  ferdium, outlook, Garuda toolbox, Blanket, calculator."

#-------------------------------------------------------- 7. Ferdium
banner "Ferdium (manual)"
manual "Log in to Ferdium and enable dark mode."

#------------------------------------------------- 8. Dock/rofi icons
banner "Fix dock/rofi icons"
echo "Sets Papirus icons for google-maps-desktop and freetube .desktop entries."
if confirm_run; then
    fix_icon() {
        local desktop="$1" icon="$2"
        if [[ -f $desktop ]]; then
            sudo sed -i "s|^Icon=.*|Icon=$icon|" "$desktop"
            ok "$(basename "$desktop") icon set."
        else
            warn "$desktop not found — skipping."
        fi
    }
    fix_icon /usr/share/applications/google-maps-desktop.desktop \
        /usr/share/icons/Papirus-Dark/128x128/apps/maps.svg
    fix_icon /usr/share/applications/freetube.desktop \
        /usr/share/icons/Papirus-Dark/128x128/apps/youtube.svg
fi

#-------------------------------------------------------- 9. GTK theme
banner "GTK theme — Graphite-blue-Dark-compact"
echo "Sets the GTK theme via gsettings (same as picking it in nwg-look)."
if confirm_run; then
    run_or_fail "set GTK theme" \
        gsettings set org.gnome.desktop.interface gtk-theme "Graphite-blue-Dark-compact"
fi

#-------------------------------------------------- 10. gptel API key
banner "gptel API key (manual)"
manual "Add your AI provider API key to the gptel configuration in Emacs." \
       "If Emacs doesn't load the config, it may not see ~/.config/emacs:" \
       "  move init.el to ~/.emacs.d/, or debug with:" \
       "  M-x org-babel-load-file ~/.config/emacs/config.org"

#---------------------------------------------------- 11. AI coding agent
banner "AI coding agent — uv, oh-my-pi, plugins, ai-projects links"
echo "Installs uv + omp, restores the backed-up OMP config, installs plugins,"
echo "and links the ai-projects skills/commands/global instructions."
if confirm_run; then
    # uv (mcp server runtime for gptel)
    if ! command -v uv >/dev/null; then
        run_or_fail "install uv" bash -c 'curl -LsSf https://astral.sh/uv/install.sh | sh'
    else
        info "uv already installed."
    fi

    # oh-my-pi
    if ! command -v omp >/dev/null; then
        run_or_fail "install oh-my-pi" bash -c 'curl -fsSL https://omp.sh/install | sh'
        warn "Log in to omp (omp auth login), then press Enter."
        read -r
    else
        info "omp already installed."
    fi

    # Restore the backed-up OMP config (dotfiles/.config/omp → ~/.omp/agent)
    omp_backup="${DOTFILES_DIR:-$HOME/dotfiles}/.config/omp"
    if [[ -d $omp_backup ]]; then
        mkdir -p "$HOME/.omp/agent"
        cp -r "$omp_backup/." "$HOME/.omp/agent/"
        ok "OMP config restored to ~/.omp/agent."
    else
        warn "No OMP config backup at $omp_backup — skipping."
    fi

    # Plugins + agent-browser
    run_or_fail "npm agent-browser" npm install -g agent-browser
    run_or_fail "omp plugin: superpowers" omp install git:github.com/obra/superpowers
    run_or_fail "omp plugin: agent-browser" omp install npm:pi-agent-browser-native
    run_or_fail "omp plugin: pi-fff" omp install npm:@ff-labs/pi-fff

    # ai-projects links (from the repo README)
    ai_dir="$HOME/desktop/workspace/ai-projects"
    if [[ -d $ai_dir/.omp ]]; then
        mkdir -p "$HOME/.omp/agent/skills" "$HOME/.omp/agent/commands" "$HOME/.agents"
        for s in "$ai_dir"/.omp/skills/*/; do
            ln -sfn "$s" "$HOME/.omp/agent/skills/$(basename "$s")"
        done
        for c in "$ai_dir"/.omp/commands/*.md; do
            ln -sfn "$c" "$HOME/.omp/agent/commands/$(basename "$c")"
        done
        ln -sfn "$ai_dir/.omp/global-instructions.md" "$HOME/.agents/AGENTS.md"
        ok "ai-projects skills, commands and global instructions linked."
    else
        warn "$ai_dir not found — run gh-sync (step 2) first, then re-run."
    fi
fi

#--------------------------------------------------- 12. Docker MCP
banner "Docker MCP — dev_workflow profile config"
echo "Applies the static profile config, then asks for the GitHub PAT."
if confirm_run; then
    run_or_fail "docker mcp profile config" docker mcp profile config dev_workflow \
        --set 'git.paths=["/home/twilight/desktop/workspace"]' \
        --set 'kubectl-mcp-server.kubeconfig=/home/twilight/.kube/config' \
        --set 'kubernetes.config_path=/home/twilight/.kube/config'

    echo
    info "Create a classic PAT: GitHub → Settings → Developer settings →"
    info "  Personal access tokens → Tokens (classic). Scopes: repo, workflow,"
    info "  read:org, gist, read:user."
    read -rp "Have the token ready? (Enter=paste it, s=skip) " tok_ready
    if [[ $tok_ready != [sS]* ]]; then
        read -rsp "GitHub PAT (input hidden): " gh_pat; echo
        if printf '%s' "$gh_pat" | docker mcp secret set github.personal_access_token; then
            ok "GitHub PAT stored as docker mcp secret."
        else
            err "Storing the secret failed — re-run this step."
        fi
        unset gh_pat
    fi

    info "Verify with: docker mcp gateway run --profile dev_workflow"
fi

#---------------------------------------------------- 13. Yazi plugins
banner "Yazi plugins (optional)"
echo "Installs 6 yazi plugins + the catppuccin-mocha flavor."
if confirm_run; then
    for pkg in yazi-rs/plugins:chmod yazi-rs/plugins:smart-enter \
               yazi-rs/plugins:full-border yazi-rs/plugins:git \
               yazi-rs/plugins:vcs-files yazi-rs/plugins:smart-filter \
               yazi-rs/flavors:catppuccin-mocha; do
        run_or_fail "ya pkg add $pkg" ya pkg add "$pkg"
    done
fi

#-------------------------------------------------------- 14. Telegram
banner "Telegram Desktop settings (manual)"
manual "Notifications and Sounds: disable 'Draw attention to the window'." \
       "Notifications and Sounds: disable 'Allow sound'." \
       "Use the QT window frame; turn off animated emojis and stickers;" \
       "  'Include muted chats in unread count' → off."

#------------------------------------------------------ 15. k10temp
banner "CPU temperature module (k10temp)"
echo "Waybar's temperature module needs the k10temp kernel module loaded."
if confirm_run; then
    if lsmod | grep -q k10temp; then
        info "k10temp already loaded."
    else
        run_or_fail "modprobe k10temp" sudo modprobe k10temp
        warn "To persist across reboots: echo k10temp | sudo tee /etc/modules-load.d/k10temp.conf"
    fi
fi

echo
ok "Post-install workflow complete ($TOTAL steps)."

