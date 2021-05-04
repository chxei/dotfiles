#!/bin/bash
baseDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
#baseDir="$(dirname "$(readlink -f "$0")")"
sudo dnf install dialog jq -y;

configFiles=('.config/zsh' '.config/autostart' '.config/conky' '.config/dolphinrc' '.config/katerc' '.config/kcminputrc' '.config/kded5rc' '.config/kdeglobals' \
            '.config/kglobalshortcutsrc' '.config/khotkeysrc' '.config/klipperrc' '.config/konsolerc' '.config/kscreenlockerrc' \
            '.config/kservicemenurc' '.config/ksplashrc' '.config/kwinrc' '.config/kxkbrc' '.config/mimeapps.list' '.config/plasma-org.kde.plasma.desktop-appletsrc' \
            '.config/plasmarc' '.config/plasmashellrc' '.config/powermanagementprofilesrc' '.kde/share/config/kdeglobals' \
            '.config/xsettingsd' '.config/smplayer/playlist.ini' '.config/smplayer/smplayer.ini' '.config/conky' '.config/kitty')

action=$(dialog --no-items --radiolist 'do you want to backup or restore' 11 30 11 \
'backup' 'on' \
'restore' 'off' \
--output-fd 1);

clear;

if [[ $action == 'backup' ]]; then
    cd ~;
    #remove history of smplayer
    gawk -i inplace '!/items\\[0-9]*\\item_/ && !/latest_dir/' ~/.config/smplayer/playlist.ini

    for file in "${configFiles[@]}"; do
        cp -r --parents "$file" "$baseDir/configs/"
    done
elif [[ $action == 'restore' ]]; then
    source $baseDir/scripts/restore.sh;
fi

#todo emergency restory
#todo git user name and mail
