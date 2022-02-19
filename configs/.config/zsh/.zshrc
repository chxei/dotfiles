umask 022
if [[ $SUDO_USER != '' && $SUDO_USER != 'root' ]] then
    HOME=/home/$SUDO_USER;
elif [[ $HOME == '/root' ]] then
    for potentialHome in /home/*; do
        [ -s "$potentialHome/Desktop" ] || continue
        HOME=$potentialHome
    done
fi
source ~/.config/zsh/exports
source ~/.config/zsh/zshopts
source ~/.config/zsh/aliases

eval "$(lua $ZSH_PLUGINS/z.lua/z.lua --init zsh enhanced once fzf)"