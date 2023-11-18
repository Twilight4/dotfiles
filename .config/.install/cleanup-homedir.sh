#!/bin/bash

cat <<"EOF"
 ____       _     _             _      _  _   _  ___  __  __ _____ 
|  _ \  ___| |__ | | ___   __ _| |_   | || | | |/ _ \|  \/  | ____|
| | | |/ _ \ '_ \| |/ _ \ / _` | __| / __) |_| | | | | |\/| |  _|  
| |_| |  __/ |_) | | (_) | (_| | |_  \__ \  _  | |_| | |  | | |___ 
|____/ \___|_.__/|_|\___/ \__,_|\__| (   /_| |_|\___/|_|  |_|_____|
                                      |_|                          
EOF

# Remove auto-generated bloat
sudo rm -rf /usr/share/fonts/encodings
sudo fc-cache -fv
rm -rf .config/{fish,gtk-3.0,ibus,kitty,micro,pulse,paru,user-dirs.dirs,user-dirs.locate,dconf}
rm -rf .config/.gsd-keyboard.settings-ported

# Setting mime type for org mode (org mode is not recognised as it's own mime type by default)
update-mime-database ~/.config/.local/share/mime
xdg-mime default emacs.desktop text/org

# Create necessary directories
directories=(
    ~/{documents,downloads,desktop,videos,music,pictures}
	  ~/videos/elfeed-youtube
    ~/desktop/{workspace,projects}
    ~/desktop/projects/company-name/{EPT,IPT}
    ~/.config/.local/share/gnupg
    ~/.config/.local/share/cargo
    ~/.config/.local/share/go
    ~/.config/.local/share/mpd/playlists
    ~/.config/.local/state/mpd
    ~/.config/.local/state/less/history
    ~/.config/.local/share/nimble
    ~/.config/.local/share/pki
    ~/.config/.local/share/cache
    ~/cachyos-repo
    ~/documents/org
)

for directory in "${directories[@]}"; do
    if [ ! -d "$directory" ]; then
        echo "Creating directory: $directory..."
        mkdir -p "$directory"
    else
        echo "Directory already exists:\n" "$directory"
    fi
done

# Cleanup home dir bloat
mv ~/.gnupg ~/.config/.local/share/gnupg
mv ~/.cargo ~/.config/.local/share/cargo
mv ~/go ~/.config/.local/share/go
mv ~/.lesshst ~/.config/.local/state/less/history
mv ~/.nimble ~/.config/.local/share/nimble
mv ~/.pki ~/.config/.local/share/pki
mv ~/.cache ~/.config/.local/share/cache
mv ~/node_modules ~/.config
mv ~/package.json ~/package-lock.json ~/.config/node_modules
mv ~/.local/share* ~/.config/.local/share
mv ~/.local/state* ~/.config/.local/state
sudo rm /home/"$(whoami)"/.bash*
rm -r ~/.local
rm -rf ~/.git
rm -r ~/{Documents,Pictures,Desktop,Downloads,Templates,Music,Videos,Public}
rm ~/.viminfo
sudo rm ~/cachyos-repo*
rm -r ~/cachyos-repo
rm ~/.zsh*
rm ~/.zcompdummp*
