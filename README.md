<div align="center">
<img src="https://img.shields.io/github/last-commit/Twilight4/dotfiles?style=for-the-badge&logo=github&color=a6da95&logoColor=D9E0EE&labelColor=302D41"/>
<img src="https://img.shields.io/github/repo-size/Twilight4/dotfiles?style=for-the-badge&logo=dropbox&color=7dc4e4&logoColor=D9E0EE&labelColor=302D41"/>
<img src="https://img.shields.io/github/stars/Twilight4/dotfiles?style=for-the-badge&logo=powerpages&color=cba6f7&logoColor=D9E0EE&labelColor=302D41"/>
</div>

## Installation
> [!CAUTION]
> Blindly copying my personal system settings and configurations without a thorough understanding can result in serious issues such as compatibility, security and performance. Take the time to assess compatibility and customize responsibly to ensure a stable and secure computing environment before running `install.sh` script. Use at your own risk.

```bash
# After first boot of Garuda
sudo pacman -Sy archlinux-keyring 
garuda-update

# Clone the repository
cd ~/downloads
git clone --depth 1 https://github.com/Twilight4/dotfiles.git ~/downloads/dotfiles

# Script install-tweaks.sh involves system-wide changes hence must be run as root
su
./dotfiles/.config/.install/install-tweaks.sh
exit

# Install dotfiles
cd dotfiles
./install.sh
```

## Contents

|      Label                     |                         Application                        |
| :----------------------------: | :--------------------------------------------------------: | 
|  **Operating System**          | [Arch Linux](https://archlinux.org/)                       |
|  **Compositor**                | [Hyprland](https://github.com/hyprwm/Hyprland)             |
|  **Status Bar**                | [Waybar](https://github.com/Alexays/Waybar/)               |
|  **App Launcher**              | [Wofi](https://hg.sr.ht/~scoopta/wofi)                     |
|  **Session Manager**           | [Wlogout](https://github.com/ArtsyMacaw/wlogout)           |
|  **Notifications**             | [Mako](https://github.com/emersion/mako)                   |
|  **Web Browser**               | [Floorp](https://floorp.app/en/)                   |
|  **Terminal**                  | [Kitty](https://sw.kovidgoyal.net/kitty/) / [Foot](https://codeberg.org/dnkl/foot)    |
|  **Terminal Multiplexer**      | [Zellij](https://github.com/zellij-org/zellij)             |
|  **Text Editor**            	 | [Emacs](https://www.gnu.org/software/emacs/)               |
|  **GTK Theme**                 | [Tokyonight-Dark](https://github.com/Fausto-Korpsvart/Tokyo-Night-GTK-Theme)          |
|  **Shell**                     | [Zsh](https://github.com/zsh-users)                        |
|  **Zsh Theme**                 | [Powerlevel10k](https://github.com/romkatv/powerlevel10k)  |
|  **Fonts**                     | [Meslo / JetBrains Mono NF](https://www.nerdfonts.com/)    |
|  **Media Player**              | [Mpv](https://mpv.io/)                                     | 
|  **Fetch Script**              | [Nitch](https://github.com/unxsh/nitch)                    |
|  **Wallpaper Loader**          | [Swww](https://github.com/Horus645/swww)                   |
|  **Wallpapers**                | [Twilight4/wallpapers](https://github.com/Twilight4/wallpapers)  |
