#!/bin/bash

set -e # Exit on error

cat <<"EOF"
 _____             _     _                             _               
| ____|_ __   __ _| |__ | | ___    ___  ___ _ ____   _(_) ___ ___  ___ 
|  _| | '_ \ / _` | '_ \| |/ _ \  / __|/ _ \ '__\ \ / / |/ __/ _ \/ __|
| |___| | | | (_| | |_) | |  __/  \__ \  __/ |   \ V /| | (_|  __/\__ \
|_____|_| |_|\__,_|_.__/|_|\___|  |___/\___|_|    \_/ |_|\___\___||___/

EOF

# Enable services if they exist and are not enabled
function enable_service {
	service=$1
	if systemctl list-unit-files --type=service | grep -q "^$service.service"; then
		if ! systemctl is-enabled --quiet "$service"; then
			echo "Enabling service: $service..."
			sudo systemctl enable "$service"
		else
			echo "Service already enabled: $service"
		fi
	else
		echo "Service does not exist: $service"
	fi
}

# Enable psd service as user if service exists and is not enabled
function enable_psd_service {
	if systemctl list-unit-files --user --type=service | grep -q "^psd.service"; then
		if ! systemctl --user is-enabled --quiet psd.service; then
			echo "Enabling service: psd.service..."
			systemctl --user enable psd.service
		else
			echo "Service already enabled: psd.service."
		fi
	else
		echo "Service does not exist: psd.service."
	fi
}

# Check what services are not enabled
function check_service_status {
	services=("$@")

	echo "Checking service status..."

	for service in "${services[@]}"; do
		if ! systemctl is-enabled "$service" >/dev/null 2>&1; then
			echo "Service $service is not enabled."
		fi
	done
}

# Define services
services=(
	"sddm"
	"apparmor"
	"firewalld"
	"irqbalance"
	"chronyd"
	"systemd-oomd"
	"systemd-resolved"
	"ananicy-cpp"
	"NetworkManager"
	"nohang"
	"preload"
	"tor"
	"supergfxd" # needed in order to use VFIO - https://wiki.archlinux.org/title/Supergfxctl
	"vnstat"    # network traffic monitor
	#docker
)

# Enable services
for service in "${services[@]}"; do
	enable_service "$service"

	# Must be set seperately to work
	sudo systemctl enable paccache.timer
	sudo systemctl enable fstrim.timer
done

# Other services
enable_psd_service # Enable psd service
hblock             # block ads and malware domains
playerctld daemon  # if it doesn't work try installing volumectl

# Check service status
check_service_status "${services[@]}"
echo "Check status of services:"
echo "    paccache.timer"
echo "    fstrim.timer"

# Commented out cuz playerctl does the job instead, not need the mpd service
# Enable mpd service as user if service exists
#if ! systemctl list-unit-files --user --type=service | grep -q "^mpd.service"; then
#    echo "Service does not exist: mpd.service. Adding and enabling..."
#    systemctl --user enable mpd.service
#else
#    if ! systemctl --user is-enabled --quiet mpd.service; then
#        echo "Enabling service: mpd.service..."
#        systemctl --user enable mpd.service                  # mpd daemon
#    else
#        echo "Service already enabled: mpd.service."
#    fi
#fi
