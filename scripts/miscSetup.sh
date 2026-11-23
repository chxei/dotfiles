#!/bin/bash


#hosts
if [[ $misc == *'hosts'* ]]; then
    sudo gio trash -f /etc/hosts;
    sudo wget -P /etc "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews/hosts";
    sudo systemctl restart NetworkManager.service;
fi


#cursor bibata classic
if [[ $misc == *'bibata-oil'* ]]; then
    cd ~/temp;
    latestversion=$(git ls-remote --tags https://github.com/ful1e5/Bibata_Cursor.git | tail -n 1 | cut -d/ -f3-);
    wget -qo - https://github.com/ful1e5/Bibata_Cursor/releases/download/$latestversion/Bibata-Modern-Classic.tar.gz;
    tar xvzf Bibata-Modern-Classic.tar.gz;
    sudo mv Bibata-* /usr/share/icons/;
    cd ~;
    # kwriteconfig5 --file ~/.config/kcminputrc --group Mouse --key cursorTheme "Bibata-Modern-Classic";
fi



#theme dependencies
sudo dnf install materia-kde kvantum -y;

#tela icon theme
install-tella(){
    cd ~/temp;
    git clone https://github.com/vinceliuice/Tela-icon-theme.git;
#     wget -qO- https://git.io/papirus-icon-theme-install | sh;
    cd Tela-icon-theme;
    ./install.sh -c black -n black;
    cd ~;
}



case $browser in
    opera)
        flatpak install --system flathub com.opera.Opera;;
    ungoogled-chromium)
        sudo dnf install chromium-browser-privacy;;
    chrome)
        sudo dnf install google-chrome-stable -y;;
    firefox)
        sudo dnf install firefox;;
esac;


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
