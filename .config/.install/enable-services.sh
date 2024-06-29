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
	"apparmor"
	"firewalld"
	"irqbalance"
	"chronyd"
	"systemd-oomd"
	"systemd-resolved"
	"ananicy-cpp"
	"NetworkManager"
	"nohang"
  "acpid"
	"vnstat"    # network traffic monitor
	#docker
)

# Enable services
for service in "${services[@]}"; do
	enable_service "$service"

	# Must be set seperately to work
	sudo systemctl enable fstrim.timer
done

# Other services
playerctld daemon

# Check service status
check_service_status "${services[@]}"
echo "Check status of services:"
echo "    fstrim.timer"
