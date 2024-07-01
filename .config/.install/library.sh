#!/bin/bash


########################
# Is package installed #
########################
_isInstalledPacman() {
    package="$1";
    check="$(sudo pacman -Qs --color always "${package}" | grep "local" | grep "${package} ")";
    if [ -n "${check}" ] ; then
        echo 0; #'0' means 'true' in Bash
        return; #true
    fi;
    echo 1; #'1' means 'false' in Bash
    return; #false
}

_isInstalledParu() {
    package="$1";
    check="$(paru -Qs --color always "${package}" | grep "local" | grep "\." | grep "${package} ")";
    if [ -n "${check}" ] ; then
        echo 0; #'0' means 'true' in Bash
        return; #true
    fi;
    echo 1; #'1' means 'false' in Bash
    return; #false
}


#####################################
# Install packages if not installed #
#####################################
_installPackagesPacman() {
    toInstall=();
    for pkg; do
        if [[ $(_isInstalledPacman "${pkg}") == 0 ]]; then
            echo ":: ${pkg} is already installed.";
            continue;
        fi;
        toInstall+=("${pkg}");
    done;

    if [[ "${toInstall[@]}" == "" ]] ; then
        # echo "All pacman packages are already installed.";
        return;
    fi;

    # printf "Package not installed:\n%s\n" "${toInstall[@]}";
    sudo pacman --noconfirm -S "${toInstall[@]}";
}

_installPackagesParu() {
    toInstall=();
    for pkg; do
        if [[ $(_isInstalledParu "${pkg}") == 0 ]]; then
            echo ":: ${pkg} is already installed.";
            continue;
        fi;
        toInstall+=("${pkg}");
    done;

    if [[ "${toInstall[@]}" == "" ]] ; then
        # echo "All packages are already installed.";
        return;
    fi;

    # printf "AUR packags not installed:\n%s\n" "${toInstall[@]}";
    paru --noconfirm -S "${toInstall[@]}";
}

################################
# Remove packages if installed #
################################
_uninstallPackagesParu() {
    toUninstall=();
    for pkg; do
        if [[ $(_isInstalledParu "${pkg}") != 0 ]]; then
            echo ":: ${pkg} is not installed.";
            continue;
        fi;
        toUninstall+=("${pkg}");
    done;

    if [[ "${toUninstall[@]}" == "" ]] ; then
        # echo "None of the packages are installed.";
        return;
    fi;

    # printf "AUR packages to be uninstalled:\n%s\n" "${toUninstall[@]}";
    paru --noconfirm -Rns "${toUninstall[@]}";
}


#########################
# Create symbolic links #
#########################
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
