#!/bin/bash

#pre-setup

sudo updatedb; #update locate database
echo "$USER ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/$USER; #allow current use executing sudo without passhord
git config --global init.defaultBranch main #get rid off silly warning about branch name
mkdir ~/temp; #


#cleanups
sudo dnf remove Yakuake firefox dragon kmahjongg kpat kmines kolourpaint kmail konversation kruler krdc krfb kcolorchooser akregator kmousetool -y;
sudo dnf remove k3b kamoso calligra-core kaddressbook korganizer kcharselect kmouth kwrite kmag dnfdragora krusader lynx fd-find fzf juk -y;


# enable rpmfusion
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y;
sudo dnf install rpmfusion-free-release-tainted rpmfusion-nonfree-release-tainted fedora-workstation-repositories -y;
sudo dnf upgrade -y --refresh;

#rpmfusion goodies
sudo dnf group install multimedia sound-and-video "Development Tools" "Development Libraries" -y;

#some usefull apps
sudo dnf install falkon plasma-browser-integration fwupd htop git neofetch jetbrains-mono-fonts-all fira-code-fonts simplescreenrecorder dnf-plugins-core dnf-plugin-system-upgrade go redhat-lsb-core lm_sensors kate ffmpeg kernel-tools ktorrent -y;

#snaps
sudo dnf install snapd -y;
sudo ln -s /var/lib/snapd/snap /snap; #allow classic snaps
sudo snap set system refresh.retain=2; #allow only 2 older versions of snaps. this is minimum allowed. default is 3

#flatpacks
sudo dnf install flatpak -y;
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo; #flathub repositorie


#wallpaper
mkdir -p ~/.local/share/wallpapers;
cp $baseDir/assets/groovy_leaf.jpg ~/.local/share/wallpapers/;
qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript '
    var allDesktops = desktops();
    print (allDesktops);
    for (i=0;i<allDesktops.length;i++) {{
        d = allDesktops[i];
        d.wallpaperPlugin = "org.kde.image";
        d.currentConfigGroup = Array("Wallpaper",
                                     "org.kde.image",
                                     "General");
        d.writeConfig("Image", "file:///~/.local/share/wallpapers/groovy_leaf.jpg")
    }}
'
