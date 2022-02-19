curl https://cli-assets.heroku.com/install.sh | sh;

sudo dnf install -y https://dbeaver.com/files/dbeaver-ee-latest-stable.x86_64.rpm;

flatpak install flatseal slack otpclient org.onlyoffice -y;

sudo pip3 install https://github.com/dlenski/vpn-slice/archive/master.zip;

sudo dnf copr enable taw/joplin -y;

sudo dnf install remmina steam foliate keepassxc conky VirtualBox joplin discord stoken-cli\
smplayer smplayer-themes \
nextcloud nextcloud-client nextcloud-client-dolphin -y;

sudo dnf install 'tlp*';
sudo systemctl mask systemd-rfkill.socket;
sudo tlp start;