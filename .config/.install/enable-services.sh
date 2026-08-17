#!/usr/bin/env bash
# Sourced by install.sh — strict mode inherited; use `return`, not `exit`.

clear
cat <<"EOF"
 _____             _     _                             _
| ____|_ __   __ _| |__ | | ___    ___  ___ _ ____   _(_) ___ ___  ___
|  _| | '_ \ / _` | '_ \| |/ _ \  / __|/ _ \ '__\ \ / / |/ __/ _ \/ __|
| |___| | | | (_| | |_) | |  __/  \__ \  __/ |   \ V /| | (_|  __/\__ \
|_____|_| |_|\__,_|_.__/|_|\___|  |___/\___|_|    \_/ |_|\___\___||___/

EOF

# Enable a service if it exists and is not already enabled
enable_service() {
    local service="$1"
    if systemctl list-unit-files --type=service | grep -q "^${service}.service"; then
        if ! systemctl is-enabled --quiet "$service"; then
            info "Enabling service: $service..."
            sudo systemctl enable "$service"
        else
            info "Service already enabled: $service"
        fi
    else
        warn "Service does not exist: $service"
    fi
}

# Report which services are still not enabled
check_service_status() {
    local services=("$@")
    local service

    info "Checking not enabled services..."

    for service in "${services[@]}"; do
        if ! systemctl is-enabled "$service" >/dev/null 2>&1; then
            warn "Service $service is not enabled."
        fi
    done
}

# Prompt the user
read -p "This will enable the necessary services. Press any key to continue or Ctrl+C to exit..." -n 1 -s
echo

# Not sure:
#"apparmor"
#"chronyd"
#"vnstat"    # network traffic monitor

# Define services
services=(
    "firewalld"
    "irqbalance"
    "systemd-oomd"
    "systemd-resolved"
    "ananicy-cpp"
    "NetworkManager"
    "nohang"
    "cronie"
    "acpid"
    "docker"
)

# Enable services
for service in "${services[@]}"; do
    enable_service "$service"
done

# Must be set separately to work
sudo systemctl enable fstrim.timer

# Espanso service and packages
#espanso service register
#espanso install typofixer-en
#espanso install contractions-en

# Other services
#playerctld daemon           # Error: Can not connect to messages bus - connection refused

# Check service status
echo
check_service_status "${services[@]}"
echo "Check status of services:"
if systemctl is-enabled --quiet fstrim.timer; then
    ok "fstrim.timer: enabled"
else
    warn "fstrim.timer: NOT enabled"
fi
