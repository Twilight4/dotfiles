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

# pm_add <desc> <url> [rev] — hyprpm add; "already installed" is success
# (makes re-runs idempotent instead of aborting run_or_fail).
pm_add() {
    local desc="$1"; shift
    local out
    if out=$(hyprpm add "$@" 2>&1); then
        ok "$desc"
    elif [[ $out == *"already installed"* ]]; then
        info "$desc — already present."
    else
        err "$desc — FAILED."
        return 1
    fi
}

# Last hyprgrass commit compatible with Hyprland 0.56.x stable: main tracks
# the 0.57-dev keybinds reorg and the v0.8.2 tag needs the older Log.hpp
# layout. Bump when Hyprland stable moves past 0.56.
HYPRGRASS_REV=56473e9e0b2da34bb3b871e90f40b3fc3d41ba9b

#================================================================ Steps ====

#-------------------------------------------------- 1. Hyprland plugins
banner "Hyprland plugins (hyprpm)"
echo "Installs + enables hyprexpo and hyprgrass (touchscreen gestures, incl."
echo "the swipe-up-from-bottom-edge on-screen keyboard toggle)."
echo "Requires a RUNNING Hyprland session."
if [[ -z ${HYPRLAND_INSTANCE_SIGNATURE:-} ]]; then
    err "Hyprland is not running in this session."
    echo "Re-run this step later inside Hyprland with:"
    echo "  $SCRIPT_DIR/post-install.sh"
    manual "Log into Hyprland, then re-run this script (skip the steps already done)."
else
    if confirm_run; then
        run_or_fail "hyprpm update" hyprpm update
        pm_add "add hyprland-plugins" https://github.com/hyprwm/hyprland-plugins
        pm_add "add hyprexpo" https://github.com/sandwichfarm/hyprexpo
        run_or_fail "enable hyprexpo" hyprpm enable hyprexpo
        pm_add "add hyprgrass" https://github.com/horriblename/hyprgrass "$HYPRGRASS_REV"
        run_or_fail "enable hyprgrass" hyprpm enable hyprgrass
        run_or_fail "hyprpm reload" hyprpm reload
    fi
fi

#--------------------------------- 2. On-screen keyboard (fcitx5 override)
banner "On-screen keyboard — activate fcitx5 override (wvkbd)"
echo "The wvkbd on-screen keyboard (toggle: swipe up from the bottom screen"
echo "edge, hyprgrass gesture from step 1) needs the seat's input-method-v2"
echo "slot, which fcitx5's waylandim frontend grabs exclusively. The deployed"
echo "drop-in ~/.config/systemd/user/omarchy-fcitx5.service.d/override.conf"
echo "disables waylandim. Trade-off: XCompose sequences stop working in"
echo "Wayland-native apps (XWayland unaffected). Omarchy-only; skipped elsewhere."
if ! systemctl --user list-unit-files 2>/dev/null | grep -q '^omarchy-fcitx5\.service'; then
    info "omarchy-fcitx5.service not found (not an Omarchy install) — skipping."
elif confirm_run; then
    run_or_fail "systemd daemon-reload" systemctl --user daemon-reload
    run_or_fail "restart omarchy-fcitx5" systemctl --user restart omarchy-fcitx5
fi

#--------------------------------------------------- 3. GNOME Keyring
banner "GNOME Keyring — empty password"
manual "The first time an app needs the keyring, a dialog appears." \
       "Just press Enter (empty password) to avoid secret-storage friction."

#----------------------------------------------------------- 4. Sync data
banner "Sync cloud data (ssh keys + FreeTube DBs via Mega, GitHub repos)"
echo "One-time mega-get pulls (~/.ssh, FreeTube DBs), pulls GitHub repos, applies small CLI fixes."
if confirm_run; then
    # megacmd (paru on Garuda, yay on Omarchy)
    if ! command -v mega-get >/dev/null; then
        if command -v paru >/dev/null; then
            run_or_fail "install megacmd" paru -S --noconfirm megacmd
        else
            run_or_fail "install megacmd" yay -S --noconfirm megacmd
        fi
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

    # One-time pulls (continuous sync is handled by the omaga-sync plugin)
    mkdir -p "$HOME/.ssh" "$HOME/.config/FreeTube"
    run_or_fail "pull ~/.ssh keys" mega-get /ssh/* "$HOME/.ssh/"
    run_or_fail "pull FreeTube DBs" mega-get /config/FreeTube/*.db "$HOME/.config/FreeTube/"
    chmod 700 "$HOME/.ssh"
    chmod 600 "$HOME/.ssh"/id_* 2>/dev/null || true

    # GitHub repos
    run_or_fail "gh-sync" zsh -c 'source ~/.config/zsh/scripts.zsh && gh-sync'

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

#---------------------------------------------------- 5. Zen browser
banner "Zen browser setup (manual)"
manual "Create a profile named 'Default (release)'." \
       "Optional: zen-browser --ProfileManager → new profile 'YouTube'," \
       "  install ad-block, log in to YouTube (for the ws-zen-yt workspace)." \
       "Apply the config: https://github.com/Twilight4/zen-browser-config" \
       "Install the Proton Pass extension and log in to GitHub."

#---------------------------------------------- 6. Zen profiles.ini
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

#-------------------------------------------------------- 7. Dock pins
banner "nwg-dock-hyprland pins (manual)"
manual "Pin on the dock: file manager, browser, camera, gnome-clocks," \
       "  freetube, Netflix, steam," \
       "  google maps, weather," \
       "  ferdium, calculator."

#--------------------------------------------------------- 8. Ferdium
banner "Ferdium (manual)"
manual "Log in to Ferdium and enable dark mode."

#------------------------------------------------------- 9. GTK theme
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

#------------------------------------------------- 11. AI coding agent
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

        # Rewrite backed-up absolute home paths (emacs MCP socket, fff-mcp)
        # to the current user's home — the JSON format can't expand $HOME itself.
        run_or_fail "mcp.json home-path rewrite" \
            sed -i "s|/home/[a-zA-Z0-9_-]*|$HOME|g" "$HOME/.omp/agent/mcp.json"
    else
        warn "No OMP config backup at $omp_backup — skipping."
    fi

    # Plugins + agent-browser
    run_or_fail "npm agent-browser" npm install -g agent-browser
    run_or_fail "omp plugin: superpowers" omp install git:github.com/obra/superpowers
    run_or_fail "omp plugin: ponytail" omp install npm:@dietrichgebert/ponytail
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
        warn "$ai_dir not found — run gh-sync (step 4) first, then re-run."
    fi

    # agent-shell dictation: sherpa-onnx venv + omp-stt-transcribe shebang
    # (the script's shebang is an absolute path to the uv tool's python)
    run_or_fail "install sherpa-onnx" uv tool install sherpa-onnx
    stt="$HOME/.config/.local/bin/omp-stt-transcribe"
    if [[ -f $stt ]]; then
        run_or_fail "omp-stt-transcribe shebang" \
            sed -i "1s|.*|#!$HOME/.config/.local/share/uv/tools/sherpa-onnx/bin/python|" "$stt"
    else
        warn "$stt not found — skipping shebang fix."
    fi
fi

#---------------------------------------------------- 12. Docker MCP
banner "Docker MCP — dev_workflow profile config"
echo "Applies the static profile config, then asks for the GitHub PAT."
if confirm_run; then
    run_or_fail "docker mcp profile config" docker mcp profile config dev_workflow \
        --set "git.paths=[\"$HOME/desktop/workspace\"]" \
        --set "kubectl-mcp-server.kubeconfig=$HOME/.kube/config" \
        --set "kubernetes.config_path=$HOME/.kube/config"

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

