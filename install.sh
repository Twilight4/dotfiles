#!/bin/sh

########
# nvim #
########
mkdir -p "$HOME/.config/nvim"
mkdir -p "$HOME/.config/nvim/undo"
ln -f "$HOME/.config/nvim/init.vim"

##############
# Xresources #
##############
#mkdir -p "$HOME/.config/x"
#mkdir -p "$HOME/.config/x/undo"
rm -rf "$HOME/.config/X11"
ln -s "$HOME/.config/x" "$HOME/.config"


#######
# zsh #
#######
#mkdir -p "$HOME/.config/zsh"
#ln -sf "$HOME/dotfiles/zsh/.zshenv" "$HOME"
#ln -sf "$HOME/dotfiles/zsh/.zshrc" "$HOME/.config/zsh"
#ln -sf "$HOME/dotfiles/zsh/aliases" "$HOME/.config/zsh/zsh-aliases"

#########
# Fonts #
#########
#mkdir -p "$XDG_DATA_HOME"
#cp -rf "$DOTFILES/fonts" "$XDG_DATA_HOME"
