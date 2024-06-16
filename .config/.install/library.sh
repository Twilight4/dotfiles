#!/bin/bash

# ------------------------------------------------------
# Create symbolic links
# ------------------------------------------------------
_installSymLink() {
    name="$1"
    symlink="$2";
    linksource="$3";
    linktarget="$4";
    
    if [ -L "${symlink}" ]; then
        rm ${symlink}
        ln -s ${linksource} ${linktarget} 
        echo "Symlink ${linksource} -> ${linktarget} created."
    else
        if [ -d ${symlink} ]; then
            rm -rf ${symlink}/ 
            ln -s ${linksource} ${linktarget}
            echo "Symlink for directory ${linksource} -> ${linktarget} created."
        else
            if [ -f ${symlink} ]; then
                rm ${symlink} 
                ln -s ${linksource} ${linktarget} 
                echo "Symlink to file ${linksource} -> ${linktarget} created."
            else
                ln -s ${linksource} ${linktarget} 
                echo "New symlink ${linksource} -> ${linktarget} created."
            fi
        fi
    fi
}
