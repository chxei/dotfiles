#!/bin/bash

#pre-setup

sudo updatedb; #update locate database
echo "$USER ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/$USER; #allow current user executing sudo without passhord
echo "net.core.default_qdisc=fq" | sudo tee -a /etc/sysctl.conf;
echo "net.ipv4.tcp_congestion_control=bbr" | sudo tee -a /etc/sysctl.conf;
echo "DNS=8.8.8.8 8.8.4.4" | sudo tee -a /etc/systemd/resolved.conf;
echo "FallbackDNS=9.9.9.9" | sudo tee -a /etc/systemd/resolved.conf;
git config --global init.defaultBranch main #get rid off silly warning about branch name
mkdir ~/temp; #
mkdir -p ~/.local/bin/;



#cleanups
sudo dnf remove Yakuake firefox dragon kmahjongg kpat kmines kolourpaint kmail konversation kruler krdc krfb kcolorchooser akregator kmousetool ktorrent -y;
sudo dnf remove k3b kamoso calligra-core kaddressbook korganizer kcharselect kmouth kwrite kmag dnfdragora krusader juk kate -y;
sudo dnf remove 'libreoffice*';

#disable useless services
sudo systemctl disable sssd.service;
sudo systemctl disable auditd.service;
sudo systemctl disable accounts-daemon.service;
sudo systemctl disable cups.service;
sudo systemctl disable sssd-kcm.service;
sudo systemctl disable colord.service;
sudo systemctl disable lvm2-monitor.service;
sudo systemctl disable lvm2-lvmpolld.socket;
sudo systemctl disable packagekit;
sudo systemctl disable firewalld;



# enable rpmfusion
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y;
sudo dnf install rpmfusion-free-release-tainted rpmfusion-nonfree-release-tainted fedora-workstation-repositories -y;
sudo dnf config-manager --set-enabled google-chrome;
sudo dnf upgrade -y --refresh;

#some usefull apps
sudo dnf install \
falkon plasma-browser-integration fwupd htop git neofetch fzf filelight qbittorrent gparted seahorse exa\
jetbrains-mono-fonts-all fira-code-fonts simplescreenrecorder \
dnf-plugins-core dnf-plugin-system-upgrade \
redhat-lsb-core lm_sensors kate ffmpeg kernel-tools bat fd-find adb \
llvm-static.x86_64 llvm-libs llvm-libs lld llvm clang-devel clang gcc glibc-devel zlib-devel libstdc++-static go cargo \
python3-pip python3 python3-devel python3-dnf-plugin-post-transaction-actions -y;

#wine
sudo dnf install wine --setopt=install_weak_deps=True --refresh --allowerasing --best --skip-broken;
sudo dnf install winetricks;
sudo dnf install binutils cabextract fuseiso p7zip-plugins polkit tor unrar unzip wget xdg-utils xz zenity;
sudo dnf install alsa-plugins-pulseaudio.i686 glibc-devel.i686 glibc-devel libgcc.i686 libX11-devel.i686 freetype-devel.i686 libXcursor-devel.i686 libXi-devel.i686 libXext-devel.i686 libXxf86vm-devel.i686 libXrandr-devel.i686 libXinerama-devel.i686 mesa-libGLU-devel.i686 mesa-libOSMesa-devel.i686 libXrender-devel.i686 libpcap-devel.i686 ncurses-devel.i686 libzip-devel.i686 lcms2-devel.i686 zlib-devel.i686 libv4l-devel.i686 libgphoto2-devel.i686 cups-devel.i686 libxml2-devel.i686 openldap-devel.i686 libxslt-devel.i686 gnutls-devel.i686 libpng-devel.i686 flac-libs.i686 json-c.i686 libICE.i686 libSM.i686 libXtst.i686 libasyncns.i686 liberation-narrow-fonts.noarch libieee1284.i686 libogg.i686 libsndfile.i686 libuuid.i686 libva.i686 libvorbis.i686 libwayland-client.i686 libwayland-server.i686 llvm-libs.i686 mesa-dri-drivers.i686 mesa-filesystem.i686 mesa-libEGL.i686 mesa-libgbm.i686 nss-mdns.i686 ocl-icd.i686 pulseaudio-libs.i686 sane-backends-libs.i686 tcp_wrappers-libs.i686 unixODBC.i686 samba-common-tools.x86_64 samba-libs.x86_64 samba-winbind.x86_64 samba-winbind-clients.x86_64 samba-winbind-modules.x86_64 mesa-libGL-devel.i686 fontconfig-devel.i686 libXcomposite-devel.i686 libtiff-devel.i686 openal-soft-devel.i686 mesa-libOpenCL-devel.i686 opencl-utils-devel.i686 alsa-lib-devel.i686 gsm-devel.i686 libjpeg-turbo-devel.i686 pulseaudio-libs-devel.i686 pulseaudio-libs-devel gtk3-devel.i686 libattr-devel.i686 libva-devel.i686 libexif-devel.i686 libexif.i686 glib2-devel.i686 mpg123-devel.i686 mpg123-devel.x86_64 libcom_err-devel.i686 libcom_err-devel.x86_64 libFAudio-devel.i686 libFAudio-devel.x86_64;

#flatpacks
sudo dnf install flatpak -y;
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo; #flathub repositorie
sudo flatpak remote-delete fedora;

#wallpaper
mkdir -p ~/.local/share/wallpapers;
cp $baseDir/assets/wallpaper.jpg ~/.local/share/wallpapers/;
plasma-apply-wallpaperimage ~/.local/share/wallpapers/wallpaper.jpg
