#!/bin/bash


#hosts
if [[ $misc == *'hosts'* ]]; then
    sudo rm -rf /etc/hosts;
    sudo wget -P /etc "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
fi

#keychron
if [[ $misc == *'keychron-fix'* ]]; then
    sudo wget -P /etc/systemd/system https://raw.githubusercontent.com/adam-savard/keychron-k2-function-keys-linux/master/script/keychron.service;
    sudo systemctl enable keychron;
    sudo systemctl start keychron;
fi


#cursor bibata classic
if [[ $misc == *'bibata-oil'* ]]; then
    cd ~/temp;
    latestffmpegversion=$(git ls-remote --tags https://github.com/ful1e5/Bibata_Cursor.git | tail -n 1 | cut -d/ -f3-);
    wget -qo - https://github.com/ful1e5/Bibata_Cursor/releases/download/$latestffmpegversion/Bibata-Modern-Classic.tar.gz;
    tar xvzf Bibata-Modern-Classic.tar.gz;
    sudo mv Bibata-* /usr/share/icons/;
    cd ~;
    kwriteconfig5 --file ~/.config/kcminputrc --group Mouse --key cursorTheme "Bibata-Modern-Classic";
fi



#theme dependencies
sudo dnf install materia-kde kvantum -y;

##parachute
cd ~/temp;
git clone https://github.com/tcorreabr/Parachute.git;
cd Parachute;
kpackagetool5 --type KWin/Script --install . || kpackagetool5 --type KWin/Script --upgrade .;
mkdir -p ~/.local/share/kservices5;
ln -s ~/.local/share/kwin/scripts/Parachute/metadata.desktop ~/.local/share/kservices5/Parachute.desktop;

##parachute togler for window edges
cd ~/temp;
git clone https://gitlab.com/divinae/toogleparachute.git;
cd toogleparachute;
kpackagetool5 --type KWin/Script --install . || kpackagetool5 --type KWin/Script --upgrade .;

#tela icon theme
install-tella(){
    cd ~/temp;
    git clone https://github.com/vinceliuice/Tela-icon-theme.git;
    wget -qO- https://git.io/papirus-icon-theme-uninstall | sh;
    cd Tela-icon-theme;
    ./install.sh -n black;
    cd ~;}


case $browser in
    opera)
        #opera
        sudo rpm --import https://rpm.opera.com/rpmrepo.key;
sudo tee /etc/yum.repos.d/opera.repo <<RPMREPO
[opera]
name=Opera packages
type=rpm-md
baseurl=https://rpm.opera.com/rpm
gpgcheck=1
gpgkey=https://rpm.opera.com/rpmrepo.key
enabled=1
RPMREPO
        sudo dnf upgrade -y --refresh;
        sudo dnf install opera-stable -y;
        cd ~/temp;
        sudo mkdir /usr/lib64/opera/lib_extra -p;
        latestffmpegversion=$(git ls-remote --tags https://github.com/iteufel/nwjs-ffmpeg-prebuilt.git | tail -n 1 | cut -d/ -f3-);
        wget -qo - https://github.com/iteufel/nwjs-ffmpeg-prebuilt/releases/download/$latestffmpegversion/$latestffmpegversion-linux-x64.zip;
        unzip $latestffmpegversion-linux-x64.zip;
        sudo cp libffmpeg.so /usr/lib64/opera/lib_extra/libffmpeg.so;
        cd ~;;
    ungoogled-chromium)
        sudo dnf install chromium-browser-privacy;;
    chrome)
        sudo dnf config-manager --set-enabled google-chrome;
        sudo dnf install google-chrome-stable -y;;
    firefox)
        sudo dnf install firefox;;
esac;


#tela icon theme
install-tella(){
    cd ~/temp;
    git clone https://github.com/vinceliuice/Tela-icon-theme.git;
    wget -qO- https://git.io/papirus-icon-theme-uninstall | sh;
    cd Tela-icon-theme;
    ./install.sh -n black;
    cd ~;
}


for file in "${configFiles[@]}"; do
    cd "$baseDir/configs/";
    cp -r --parents "$file" "$HOME" 
done

if [[ $icontheme == *'breeze-dark'* ]]; then
    /usr/libexec/plasma-changeicons breeze-dark;
elif [[ $icontheme == *'breeze-light'* ]]; then
    /usr/libexec/plasma-changeicons breeze;
elif [[ $icontheme == *'tela-black-dark'* ]]; then
    install-tella;
    /usr/libexec/plasma-changeicons black-dark;
elif [[ $icontheme == *'tela-black'* ]]; then
    install-tella;
    /usr/libexec/plasma-changeicons black;
fi


if [[ $theme == *'breezedark'* ]]; then
    lookandfeeltool -a 'org.kde.breezedark.desktop'
elif [[ $theme == *'breezelight'* ]]; then
    lookandfeeltool -a 'org.kde.breeze.desktop'
elif [[ $theme == *'breezetwilight'* ]]; then
    lookandfeeltool -a 'org.kde.breezetwilight.desktop'
elif [[ $theme == *'materialight'* ]]; then
    lookandfeeltool -a 'com.github.varlesh.materia-light'
elif [[ $theme == *'materiadark'* ]]; then
    lookandfeeltool -a 'ocom.github.varlesh.materia-dark'
fi
