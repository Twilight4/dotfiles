#!/usr/bin/env bash
# Sourced by install.sh — use `return`, not `exit`.

clear
cat <<"EOF"
             _                                __
  __ _ _   _| |_ ___         ___ _ __  _   _ / _|_ __ ___  __ _
 / _` | | | | __/ _ \ _____ / __| '_ \| | | | |_| '__/ _ \/ _` |
| (_| | |_| | || (_) |_____| (__| |_) | |_| |  _| | |  __/ (_| |
 \__,_|\__,_|\__\___/       \___| .__/ \__,_|_| |_|  \___|\__, |
                                |_|                          |_|

EOF

# Prompt the user
read -p "This will install auto-cpufreq. Press any key to continue or Ctrl+C to exit..." -n 1 -s
echo

if ! command -v auto-cpufreq >/dev/null; then
    echo
    info "Installing auto-cpufreq..."

    # Build in a temp dir that is always cleaned up, even on failure
    # (the old version leaked ./auto-cpufreq when the installer failed).
    build_dir=$(mktemp -d)
    git clone --depth 1 https://github.com/AdnanHodzic/auto-cpufreq.git "$build_dir/auto-cpufreq"
    (cd "$build_dir/auto-cpufreq" && sudo ./auto-cpufreq-installer)
    # To disable and remove auto-cpufreq daemon, run: sudo auto-cpufreq --remove
    sudo auto-cpufreq --install
    rm -rf "$build_dir"

    ok "auto-cpufreq installed."
else
    echo
    info "auto-cpufreq is already installed. Skipping..."
fi
