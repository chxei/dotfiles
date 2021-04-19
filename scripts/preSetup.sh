#!/bin/bash

updatedb; #update locate database
#pre-setup
echo "$USER ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/$USER; #allow current use executing sudo without passhord
mkdir temp; #
sudo dnf upgrade -y --refresh;


#cleanups
sudo dnf remove Yakuake firefox dragon kmahjongg kpat kmines kolourpaint kmail konversation kruler krdc krfb kcolorchooser akregator kmousetool -y;
sudo dnf remove k3b kamoso calligra-core kaddressbook korganizer kcharselect kmouth kwrite kmag dnfdragora krusader lynx fd-find fzf -y;


# enable rpmfusion
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y;
sudo dnf upgrade -y --refresh;
sudo dnf install rpmfusion-free-release-tainted rpmfusion-nonfree-release-tainted -y;
sudo dnf install fedora-workstation-repositories -y;

#rpmfusion goodies
sudo dnf group install multimedia sound-and-video "Development Tools" "Development Libraries" -y;

#some usefull apps
sudo dnf install falkon plasma-browser-integration fwupd htop git neofetch jetbrains-mono-fonts-all fira-code-fonts simplescreenrecorder dnf-plugins-core go redhat-lsb-core lm_sensors kate ffmpeg kernel-tools -y;

#snaps
sudo dnf install snapd -y;
sudo ln -s /var/lib/snapd/snap /snap; #allow classic snaps
sudo snap set system refresh.retain=2; #allow only 2 older versions of snaps. this is minimum allowed. default is 3

#flatpacks
sudo dnf install flatpak -y;
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo -y; #flathub repositorie

#optimizations
echo 'CPUPOWER_START_OPTS="frequency-set -g schedutil"\nCPUPOWER_STOP_OPTS="frequency-set -g schedutil"' | sudo tee /etc/sysconfig/cpupower; #set default governor to schedutil
sudo cpupower frequency-set -g schedutil;
sudo systemctl enable --now cpupower;

#wallpaper
mkdir -p ~/.local/share/wallpapers;
cp $baseDir/assets/groovy_leaf.jpg ~/.local/share/wallpapers/;
