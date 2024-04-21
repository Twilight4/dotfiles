#!/bin/bash

# this script enters each dir and renames the .md files to the name of the directories and moves them to ../ and removes all dirs

for dir in */; do
    dir=${dir%*/}  # Remove trailing '/'
    \cd "$dir" || continue  # Enter directory

    # Rename file 'system.md' to be the same as directory name
    if [ -f system.md ]; then
        \mv system.md "../$dir.md"
    fi

    \cd - > /dev/null  # Go back to previous working directory

    # Remove all directories in current working directory
    find . -mindepth 1 -maxdepth 1 -type d -exec rm -r {} +
done
