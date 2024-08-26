#!/bin/bash

clear
cat <<"EOF"
 ____       _     _             _      _  _   _  ___  __  __ _____ 
|  _ \  ___| |__ | | ___   __ _| |_   | || | | |/ _ \|  \/  | ____|
| | | |/ _ \ '_ \| |/ _ \ / _` | __| / __) |_| | | | | |\/| |  _|  
| |_| |  __/ |_) | | (_) | (_| | |_  \__ \  _  | |_| | |  | | |___ 
|____/ \___|_.__/|_|\___/ \__,_|\__| (   /_| |_|\___/|_|  |_|_____|
                                      |_|                          
EOF

# Prompt the user
read -p "Do you want to debloat the \$HOME directory? (y/n): " response
echo

if [[ "$response" != "y" ]]; then
    echo "Operation cancelled by the user."
    exit 0
fi

# Create necessary directories
directories=(
    ~/{documents,downloads,desktop,videos,music,pictures}
    ~/pictures/{dcim,screenshots}
    ~/videos/elfeed-youtube
    ~/documents/{pdfs,openvpn}
    ~/desktop/{workspace,projects,server}
    ~/.config/.local/share/gnupg
    ~/.config/.local/share/cargo
    ~/.config/.local/share/go
    ~/.config/.local/share/mpd/playlists
    ~/.config/.local/state/mpd
    ~/.config/.local/state/less/history
    ~/.config/.local/share/nimble
    ~/.config/.local/share/pki
    ~/.config/.local/share/cache
)

if [ ! -d "/opt/tools" ]; then
  sudo mkdir -p /opt/tools
fi

for directory in "${directories[@]}"; do
    if [ ! -d "$directory" ]; then
        echo "Creating directory: $directory..."
        mkdir -p "$directory"
    else
        echo "Directory already exists: $directory"
    fi
done

# Function to move a file or directory if it exists
move_if_exists() {
    if [ -e "$1" ]; then
        mv -v "$1" "$2"
    fi
}

# Move directories and files if they exist
move_if_exists ~/.gnupg ~/.config/.local/share/gnupg
move_if_exists ~/.cargo ~/.config/.local/share/cargo
move_if_exists ~/go ~/.config/.local/share/go
move_if_exists ~/.lesshst ~/.config/.local/state/less/history
move_if_exists ~/.nimble ~/.config/.local/share/nimble
move_if_exists ~/.pki ~/.config/.local/share/pki
move_if_exists ~/.cache ~/.config/.local/share/cache
move_if_exists ~/node_modules ~/.config
move_if_exists ~/package.json ~/.config/node_modules/package.json
move_if_exists ~/package-lock.json ~/.config/node_modules/package-lock.json

# Move .local/share* and .local/state* if they exist
for dir in ~/.local/share*; do
    move_if_exists "$dir" ~/.config/.local/share
    echo "Moving directory: $dir..."
done

for dir in ~/.local/state*; do
    move_if_exists "$dir" ~/.config/.local/state
    echo "Moving directory: $dir..."
done

# Remove specific files and directories
sudo rm -vf /home/"$(whoami)"/.bash*
rm -vrf ~/.local
rm -vrf ~/.git
rm -vrf ~/Documents ~/Pictures ~/Desktop ~/Downloads ~/Templates ~/Music ~/Videos ~/Public
rm -vf ~/.viminfo
rm -vf ~/.zsh*
rm -vf ~/.zcompdump*
rm -vf ~/.dircolors
rm -vf ~/.Xresources
rm -vf ~/.zcompdump
rm -vf ~/.profile
rm -vf ~/.gtkrc-2.0
rm -vf ~/.gitconfig
rm -vf ~/.zhistory
rm -vf ~/.zshrc

# Wait 2 sec before clear so user knows what happened
sleep 2
