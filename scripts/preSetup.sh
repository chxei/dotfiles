#!/bin/bash

#pre-setup

sudo updatedb; #update locate database
echo ERRFILE DEFAULT="\$XDG_CACHE_HOME/X11/xsession-errors" | sudo tee -a /etc/security/pam_env.conf;
echo ICEAUTHORITY DEFAULT="\${XDG_RUNTIME_DIR}/ICEauthority" | sudo tee -a /etc/security/pam_env.conf;
echo XAUTHORITY DEFAULT="\${XDG_RUNTIME_DIR}/Xauthority" | sudo tee -a /etc/security/pam_env.conf;

echo "$USER ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/$USER; #allow current user executing sudo without passhord
echo "net.core.default_qdisc=fq" | sudo tee -a /etc/sysctl.conf;
echo "net.ipv4.tcp_congestion_control=bbr" | sudo tee -a /etc/sysctl.conf;
echo "FallbackDNS=8.8.8.8 8.8.4.4" | sudo tee -a /etc/systemd/resolved.conf;
echo "DNS=9.9.9.9" | sudo tee -a /etc/systemd/resolved.conf;
git config --global init.defaultBranch main; #get rid off silly warning about branch name
git config --global push.autoSetupRemote true; #auto setup remote repo if not exist
git config --global user.email "chxei5667@gmail.com";
git config --global user.name "chxei";

mkdir ~/temp; #
mkdir -p ~/.local/bin/;
mkdir -p /home/$USER/.config/simplescreenrecorder/;
mkdir -p /home/$USER/.config/nvidia/;

sudo cpupower frequency-set -g schedutil;
sudo sysctl -w net.ipv4.tcp_congestion_control=bbr2; #failed sysctl: setting key "net.ipv4.tcp_congestion_control": No such file or directory

#cleanups
sudo dnf remove Yakuake firefox dragon kmahjongg kpat kmines kolourpaint kmail konversation kruler krdc krfb kcolorchooser akregator kmousetool ktorrent kgames -y;
sudo dnf remove k3b kamoso calligra-core kaddressbook korganizer kcharselect kmouth kwrite kmag dnfdragora krusader juk falkon PackageKit PackageKit-glib -y;
sudo dnf remove 'libreoffice*' -y;
sudo dnf remove 'vlc*' -y;
sudo dnf remove 'plasma-discover-*' -y;
sudo dnf install flatpak -y;

#disable useless services
sudo systemctl disable sssd.service;
sudo systemctl disable auditd.service;
sudo systemctl disable accounts-daemon.service;
sudo systemctl disable cups.service;
sudo systemctl disable sssd-kcm.service;
sudo systemctl disable colord.service;
sudo systemctl disable lvm2-monitor.service lvm2-lvmpolld.socket;
sudo systemctl disable packagekit;
sudo systemctl disable firewalld sshd;
sudo systemctl disable smartd.service;
sudo systemctl disable abrtd.service abrt-journal-core.service abrt-oops.service abrt-vmcore.service abrt-xorg.service;



# enable rpmfusion
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y;
sudo dnf install rpmfusion-free-release-tainted rpmfusion-nonfree-release-tainted fedora-workstation-repositories -y;
sudo dnf config-manager --set-enabled google-chrome;
sudo dnf upgrade -y --refresh;

#some usefull apps
sudo dnf install \
plasma-browser-integration fwupd htop git neofetch fzf filelight qbittorrent gparted seahorse eza bleachbit \
jetbrains-mono-fonts-all fira-code-fonts simplescreenrecorder \
dnf-plugins-core dnf-plugin-system-upgrade screen \
redhat-lsb-core lm_sensors kate ffmpeg kernel-tools bat fd-find adb inxi \
llvm-static.x86_64 llvm-libs llvm-libs lld llvm clang-devel clang gcc glibc-devel zlib-devel libstdc++-static go cargo \
python3-pip python3 python3-devel python3-dnf-plugin-post-transaction-actions -y;

#flatpacks
sudo dnf install flatpak -y;
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo; #flathub repositorie
sudo flatpak remote-delete fedora;

#wallpaper
mkdir -p ~/.local/share/wallpapers;
cp $baseDir/assets/wallpaper.jpg ~/.local/share/wallpapers/;
plasma-apply-wallpaperimage ~/.local/share/wallpapers/wallpaper.jpg
