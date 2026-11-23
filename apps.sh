flatpak install slack otpclient org.onlyoffice.desktopeditors com.github.PintaProject.Pinta \
io.gitlab.metadatacleaner.metadatacleaner com.google.AndroidStudio com.github.huluti.Curtail com.mastermindzh.tidal-hifi \
com.github.qarmin.czkawka com.stremio.Stremio com.anydesk.Anydesk com.github.tchx84.Flatseal hu.irl.cameractrls net.agalwood.Motrix one.ablaze.floorp org.telegram.desktop -y;

sudo pip3 install https://github.com/dlenski/vpn-slice/archive/master.zip;

sudo dnf copr enable taw/joplin -y;
sudo dnf copr enable atim/bottom -y;

sudo tee /etc/yum.repos.d/charm.repo >/dev/null <<'EOF' || exit 1
[charm]
name=Charm
baseurl=https://repo.charm.sh/yum/
enabled=1
gpgcheck=1
gpgkey=https://repo.charm.sh/yum/gpg.key
EOF


sudo dnf install steam foliate keepassxc conky VirtualBox joplin discord \
ShellCheck stress gwe pipewire-codec-aptx bottom zpaq qalc microcode_ctl strawberry micro \
glow \
mangohud goverlay -y;
#nextcloud nextcloud-client nextcloud-client-dolphin
