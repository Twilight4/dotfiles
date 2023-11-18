#!bin/bash

echo "Checking if rsync is installed..."
_installPackagesPacman "rsync";
echo "Checking if git is installed..."
_installPackagesPacman "git";
echo "Checking if ccache is installed..."
_installPackagesPacman "ccache";
