#!/bin/bash

source $baseDir/scripts/preSetup.sh;
source $baseDir/scripts/appsSetup.sh;


for key in $(jq ".apps | keys | .[]" $baseDir/appsList.json); do
    value=$(jq --raw-output ".apps[$key]" $baseDir/appsList.json);
    app=$(jq --raw-output  ".app" <<< $value);
    description=$(jq  --raw-output ".description" <<< $value);
    state=$(jq --raw-output ".state" <<< $value);
    appsString+="'$key' '$app - $description' '$state' "
done

apps=$(eval dialog --no-tags --checklist \'Choose which apps do you want to use\' 35 100 35 $appsString --output-fd 1);

cat <<< $(jq '.apps[].state = "off"' $baseDir/appsList.json) > $baseDir/appsList.json
for key in $apps
do
    cat <<< $(jq ".apps[$key].state = \"on\"" $baseDir/appsList.json) > $baseDir/appsList.json;
done

for key in $(jq '.[] | map(select(.state == "on")) | keys | .[]' $baseDir/appsList.json); do
    value=$(jq ".[] | map(select(.state == \"on\")) | .[$key]" $baseDir/appsList.json); 
    app=$(jq --raw-output  ".app" <<< $value);
    description=$(jq  --raw-output ".description" <<< $value);
    state=$(jq --raw-output ".state" <<< $value);
    source=$(jq --raw-output ".source" <<< $value);
    script=$(jq --raw-output ".script?" <<< $value);
    repo=$(jq --raw-output ".repo?" <<< $value);
    package=$(jq --raw-output ".package?" <<< $value);
    if [[ $package == 'null' ]]; then
        package=$app;
    fi;
    if [[ $source == 'dnf' ]]; then
        if [[ $repo != 'null' ]]; then
            sudo dnf copr enable $repo -y;
        fi
        sudo dnf install $package -y;
    elif [[ $source == 'snap' ]]; then
        sudo snap install $package;
    elif [[ $source == 'snapClassic' ]]; then
        sudo snap install $package --classic;
    elif [[ $source == 'flatpak' ]]; then
        sudo flatpak install $package -y;
    elif [[ $source == 'script' ]]; then
        $script;
    fi
done

clear;

theme=$(dialog --radiolist 'Choose theme. Hit cencel to stick with fedoras default theme' 20 100 20 \
'breeze-dark' 'kdes default dark theme(recommended)' 'on' \
'breeze-light' 'kdes default light theme' 'off' \
'breeze-twilight' 'light app theme, dark environtment' 'off' \
'materia-light' 'minimalistic light theme' 'off' \
'materia-dark' 'minimalistic dark theme' 'off' \
--output-fd 1
);

clear;


icontheme=$(dialog --radiolist 'Choose icon theme. Hit cencel to stick with fedoras default icons' 20 100 20 \
'breeze-dark' 'kdes default icons for dark theme(recommended)' 'on' \
'breeze-light' 'kdes default icons for light themes' 'off' \
'tela-black' 'modern, flat icon theme with black folders' 'off' \
'tela-black-dark' 'tela icons for dark theme' 'off' \
--output-fd 1
);

clear;


misc=$(dialog --checklist 'Choose cursor theme. Hit cencel to stick with fedoras default icons' 20 100 20 \
'bibata-oil' 'modern cursor theme' 'on' \
'hosts' 'apply system wide, hosts based adblocker' 'on' \
'keychron-fix' 'use only if you have keychrons wireless keyboard' 'off' \
--output-fd 1
);

clear;


browser=$(dialog --radiolist 'What browser do you want to install?' 15 30 10 'opera' '' 'on' 'chrome' '' 'off' 'firefox' '' 'off' 'ungoogled-chromium' '' 'off' --output-fd 1);

clear;

if dialog --defaultno --yesno 'Do you want to install nvidia drivers?' 10 30 --output-fd 1; then
    sudo dnf remove xorg-x11-drv-nouveau -y;
    sudo dnf install akmod-nvidia vulkan vdpauinfo libva-vdpau-driver libva-utils xorg-x11-drv-nvidia-cuda-libs xorg-x11-drv-nvidia-cuda -y;
    sudo akmods --force;
    sudo dracut --force;
    sudo grubby --update-kernel=ALL --args='nvidia-drm.modeset=1';
    grub-update;
fi

clear;

source $baseDir/scripts/miscSetup.sh;


source $baseDir/scripts/postSetup.sh;
