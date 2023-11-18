#!/bin/bash

cat <<"EOF"
                                 __         _ 
 ___ _   _ _ __   ___ _ __ __ _ / _|_  ____| |
/ __| | | | '_ \ / _ \ '__/ _` | |_\ \/ / _` |
\__ \ |_| | |_) |  __/ | | (_| |  _|>  < (_| |
|___/\__,_| .__/ \___|_|  \__, |_| /_/\_\__,_|
          |_|             |___/               
EOF

read -p "Do you want to create supergfxd configuration? (y/n): " configure_choice

if [[ "$configure_choice" =~ ^[Yy]$ ]]; then
    if command -v supergfxd >/dev/null; then
        echo "Creating supergfxd configuration..."

        # Create supergfxd.conf
        echo '{
          "mode": "Hybrid",
          "vfio_enable": true,
          "vfio_save": false,
          "always_reboot": false,
          "no_logind": false,
          "logout_timeout_s": 180,
          "hotplug_type": "Asus"
        }' | sudo tee /etc/supergfxd.conf > /dev/null

        echo "supergfxd.conf created."
    else
        echo "Supergfxd is not installed."
    fi
else
    echo "Configuration of supergfxd canceled by user."
fi
