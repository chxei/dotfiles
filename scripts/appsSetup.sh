#!/bin/bash

#zsh cod
installZsh(){
    sudo dnf install zsh -y;
    #change default shell for zsh
    chsh -s /bin/zsh;
    sudo chsh -s /bin/zsh;
    go get -u github.com/dim-an/cod;
    mv ~/go/bin/cod ~/.local/bin
    #download some cool zsh plugins
    mkdir .local/bin/zsh_plugins -p;
    cd .local/bin/zsh_plugins;
    git clone https://github.com/denysdovhan/spaceship-prompt.git;
    git clone https://github.com/skywind3000/z.lua.git;
    git clone https://github.com/zsh-users/zsh-autosuggestions.git;
    git clone https://github.com/zsh-users/zsh-completions.git;
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git;
    wget -qo - https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh
    wget -qo - https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/command-not-found/command-not-found.plugin.zsh
    wget -qo - https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/common-aliases/common-aliases.plugin.zsh
    wget -qo - https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/extract/extract.plugin.zsh
    wget -qo - https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/bgnotify/bgnotify.plugin.zsh
    ##for gll alias
    git config --global alias.ll 'log --graph --format="%C(yellow)%h%C(red)%d%C(reset) - %C(bold green)(%ar)%C(reset) %s %C(blue)<%an>%C(reset)"'
    #remove default configs
    rm -rf ~/.zshrc;
    rm -rf /root/.zshrc;
    #restore saved .zshrc
    sudo cp $baseDir/home/.zshrc ~/.zshrc;
    #make same config for root. copy because cross partition symlinks are not available
    sudo cp ~/.zshrc /root/.zshrc;
}

installZoom(){
    sudo rpm --import https://zoom.us/linux/download/pubkey;
    sudo dnf install https://zoom.us/client/latest/zoom_x86_64.rpm -y;
}

installJava(){
    sudo dnf install java-latest-openjdk java-latest-openjdk-devel java-latest-openjdk-jmods -y;
    curl -s "https://get.sdkman.io" | zsh;
    source "$HOME/.sdkman/bin/sdkman-init.sh";
    sdk install springboot;
    sdk install gradle;
    sdk install maven;
    sdk install tomcat;
}

installVscode(){
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc;
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo';
    sudo dnf install code -y;
}

installTidalDl(){
    pip3 install tidal-dl --upgrade
}


installGzdoom(){
    sudo dnf copr enable nalika/gzdoom -y;
    sudo dnf install gzdoom -y;
}

installVirtualBox(){
    sudo dnf install VirtualBox kernel-devel-$(uname -r) akmod-VirtualBox VirtualBox-guest-additions -y;
    sudo akmods;
    sudo systemctl restart systemd-modules-load && sudo systemctl restart vboxservice && sudo systemctl restart vboxdrv;
}
