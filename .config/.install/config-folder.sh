#!bin/bash

if [ -d ~/.config ]; then
    echo ".config folder already exists."
else
    mkdir -p ~/.config
    echo ".config folder created."
fi
echo ""
