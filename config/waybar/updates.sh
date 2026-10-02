#!/bin/bash

logfile=/$HOME/.local/logs/updates.txt

#------------------------------------ Definables ---------------------------------------------------
teelog(){
    tee -a $logfile
}

#------------------------------------ Variables ---------------------------------------------------
pkglist=""
pkgup=0
rmcache=0
orpkgnum=$(pacman -Qtdq | wc -w)

#------------------------------------ Functions ---------------------------------------------------
ins_sep(){
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" | teelog
}
blank() {
    echo | teelog
}
timestamp() {
    echo [$(date)] | teelog
}
completion_stamp() {
    timestamp
    ins_sep
}

#------------------------------------ scripts -----------------------------------------------------
check_upgradable() {
    pacman -Sy
    pkgup=$(pacman -Qu | wc -l)

    if [ $pkgup -eq 0 ]; then
    echo -e "There are no updates available at this time." | teelog
    completion_stamp
    blank
    notify-send "No updates available"
    paplay /usr/share/sounds/freedesktop/stereo/complete.oga
    exit 0
    fi

    pkglist=$(pacman -Qu)
    echo "Packages with update available:" | teelog
    echo -e "$pkglist"
    echo "$pkglist" >> $logfile
    blank
}

pac_orphans(){
    echo "Checking for orphaned packages... " | teelog
    echo -n "$orpkgnum orphaned packages have been found." | teelog
    if [ $orpkgnum -gt 0 ]; then
        echo "   Removing orphaned packages... " | teelog
        if PAC_OR="$(pacman -Qtdq | pacman -Rns --noconfirm - )"; then
            echo $PAC_OR | teelog
            echo -e "Done."
            echo
        else
            echo -n "   Error removing orphans." | teelog
            echo " Check log: $logfile" | teelog
            completion_stamp
            blank
            exit 1
        fi
    else
        echo -e "  No orphans found, nothing to do."
        blank
    fi
}

main_script(){
    notify-send "Starting System Update..."
    paplay /usr/share/sounds/freedesktop/stereo/complete.oga
    blank
    ins_sep
    echo "[$(date)] System update script initiated..." | teelog
    check_upgradable

    # Update the package lists and upgrade the system
    echo "Updating with pacman..." | teelog
    kitty sudo pacman -Sqyu --noconfirm | teelog 2>&1

    # Clean up unused packages and old versions of installed packages
    pac_orphans
    if [[ $rmcache = 1 ]]; then
        echo "Pacman cache clean option selected."
        echo "Removing all but last 3 versions of archived packages in cache..."
        paccache -r | teelog
    fi

    echo "Update script has completed successfully." | teelog
    completion_stamp
    blank
    notify-send "Update Complete!"
    paplay /usr/share/sounds/freedesktop/stereo/complete.oga
}

#----------------------------- Executables --------------------------------------------------
main_script
