# Created by newuser for 5.8
if [[ $SUDO_USER != '' && $SUDO_USER != 'root' ]] then
    HOME=/home/$SUDO_USER;
fi
export PATH=$PATH:$HOME/.local/bin
export JAVA_HOME=/usr/lib/jvm/java-11
export PATH=$PATH:$JAVA_HOME/bin
export LOCALBIN=$HOME/.local/bin
export ZSH_PLUGINS=$LOCALBIN/zsh_plugins
export FZF_DEFAULT_COMMAND='fd --color=never -H -I -E .git'
export FZF_DEFAULT_OPTS='--height 75% --multi --reverse --preview="head -$LINES {}" '
TERM=vt100
bgnotify_threshold=60

#options
setopt correct                                                  # Auto correct mistakes
setopt extendedglob                                             # Extended globbing. Allows using regular expressions with *
setopt nocaseglob                                               # Case insensitive globbing
setopt rcexpandparam                                            # Array expension with parameters
setopt numericglobsort                                          # Sort filenames numerically when it makes sense
setopt nobeep                                                   # No beep
setopt share_history                                            # Immediately append history instead of overwriting
setopt histignorealldups                                        # If a new command is a duplicate, remove the older one
setopt autocd                                                   # if only directory path is entered, cd there.
setopt cdablevars                                               # add ~/ to dir if its not found in current dir # არ მუშაობს :pain:
setopt complete_aliases

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'       # Case insensitive tab completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"         # Colored completion (different colors for dirs/files/etc)
zstyle ':completion:*' rehash true                              # automatically find new executables in path 
zstyle ':completion:*' menu select                              # arrow navigation in autocomplete
#Speed up completions
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.config/zsh/.zhistory
WORDCHARS=${WORDCHARS//\/[&.;]}                                 # Don't consider certain characters part of the word

# Alias section
alias open="xdg-open"
alias cp="cp -i"                                                # Confirm before overwriting something
alias df='df -h'                                                # Human-readable sizes
alias free='free -m'                                            # Show sizes in MB
alias gitu='git add . && git commit && git push'
alias la='ls -ah'
alias ll='ls -alh'
alias ls='ls -h --color=auto'
alias pacpurge='sudo pacman -Rsn $(pacman -Qdtq)'
alias pacpuurge='sudo pacman -Rsn $(pacman -Qdttq)'
alias vim='nvim'
alias grep="grep --color=auto"
alias config='/usr/bin/git --git-dir=$HOME/.config/dotfiles/ --work-tree=$HOME'
alias recvkeys='gpg --keyserver keys.gnupg.net --recv-keys'
alias zrc='kate ~/.zshrc'
alias cpumonitor='watch -n.1 "cat /proc/cpuinfo | grep \"^[c]pu MHz\""'
alias screenon='xrandr --output HDMI-A-0 --primary --mode 1920x1080 --refresh 144.00 --output eDP --left-of HDMI-A-0; xset dpms force on;'
alias screenoff='xrandr --output HDMI-A-0 --off --output eDP --primary; sleep 3; xset dpms force off'
alias prime-run='__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia __GLX_VENDOR_LIBRARY_NAME=nvidia'
alias fnano='fzf_find_edit nano'
alias fkate='fzf_find_edit kate'
alias z='z -I'
alias \?='duckduckgo'
# Transform the arguments into a valid url querystring
urlencode()
{
  local args="$@"
  jq -nr --arg v "$args" '$v|@uri'; 
}

# Query duckduckgo
duckduckgo ()
{
  lynx "https://lite.duckduckgo.com/lite/?q=$(urlencode "$@")"
}


fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}
gitlog() {
    local selections=$(
      git ll --color=always "$@" |
        fzf --ansi --no-sort --no-height \
            --preview "echo {} | grep -o '[a-f0-9]\{7\}' | head -1 |
                       xargs -I@ sh -c 'git show --color=always @'"
      )
    if [[ -n $selections ]]; then
        local commits=$(echo "$selections" | sed 's/^[* |]*//' | cut -d' ' -f1 | tr '\n' ' ')
        git show $commits
    fi
}
gitadd() {
    local selections=$(
      git status --porcelain | \
      fzf --ansi \
          --preview 'if (git ls-files --error-unmatch {2} &>/dev/null); then
                         git diff --color=always {2}
                     else
                         bat --color=always --line-range :500 {2}
                     fi'
      )
    if [[ -n $selections ]]; then
        local files=$(echo "$selections" | cut -c 4- | tr '\n' ' ')
        git add --verbose $files
    fi
}
fkill() {
    local pid 
    if [ "$UID" != "0" ]; then
        pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    fi  

    if [ "x$pid" != "x" ]
    then
        echo $pid | xargs kill -${1:-9}
    fi  
}
fcd() {
    local directory=$(
      fd --type d | \
      fzf --query="$1" --no-multi --select-1 --exit-0 \
          --preview 'tree -C {} | head -100'
      )
    if [[ -n $directory ]]; then
        cd "$directory"
    fi
}
fzf_find_edit() {
    local file=$(fzf --query="$2" --no-multi --select-1 --exit-0 --preview 'bat --color=always --line-range :500 {}' )
    if [[ -n $file ]]; then
        $1 "$file"
    fi
}

grub-update(){
    sudo grub2-mkconfig -o "$(readlink -e /etc/grub2-efi.cfg)";
    sudo grub2-mkconfig -o "$(readlink -e /etc/grub2.cfg)";
}
update-all(){
    sudo flatpak update -y;
    sudo snap refresh;
    sudo dnf upgrade --refresh -y;
    sdk update;
    sudo fwupdmgr update;
    cd $ZSH_PLUGINS;
    ls -d */ | xargs -I{} git -C {} reset --hard;
    ls -d */ | xargs -I{} git -C {} pull;
    cd ~;
}
clean-all(){
    sudo dnf clean all -y;
    sudo dnf autoremove -y;
    sudo dnf remove --duplicates -y;
    sudo dnf remove --oldinstallonly -y;
    flatpak uninstall --unused;
    sdk flush;
    sudo journalctl --rotate --vacuum-size=500M;
    rm -rf ~/.cache/*;
    rm -rf ~/.thumbnails/*
    rm -rf ~/.wget-hsts;
    rm -rf ~/.xsession-errors*;
    rm -rf ~/.lesshs*;
    sudo find /var/log/. ! -type d -delete;
}

# double esc to sudo plugin
source $ZSH_PLUGINS/sudo.plugin.zsh

#autocomplete, highlighting and suggestions
autoload -Uz compinit; compinit
fpath=($ZSH_PLUGINS/zsh-completions/src $fpath)
source $ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZSH_PLUGINS/command-not-found.plugin.zsh
source $ZSH_PLUGINS/common-aliases.plugin.zsh
source $ZSH_PLUGINS/bgnotify.plugin.zsh
source $ZSH_PLUGINS/extract.plugin.zsh
eval "$(lua $ZSH_PLUGINS/z.lua/z.lua --init zsh enhanced once fzf)"
source <(cod init $$ zsh)
#todo z autocomplete not working
#todo fzf ctrl + t not working; source /usr/share/fzf/shell/key-bindings.zsh; 



# key bindings
# Navigate words with ctrl+arrow keys
bindkey '^[Oc' forward-word                                     #
bindkey '^[Od' backward-word                                    #
bindkey '^[[1;5D' backward-word                                 #
bindkey '^[[1;5C' forward-word                                  #
bindkey '^H' backward-kill-word                                 # delete previous word with ctrl+backspace
bindkey '^[[Z' undo                                             # Shift+tab undo last action
bindkey '^[' autosuggest-clear

#theme
source $ZSH_PLUGINS/spaceship-prompt/spaceship.zsh-theme
SPACESHIP_PROMPT_ADD_NEWLINE="false" #default true
SPACESHIP_PROMPT_FIRST_PREFIX_SHOW="true" #default false
SPACESHIP_PROMPT_PREFIXES_SHOW="true"
SPACESHIP_PROMPT_SUFFIXES_SHOW="true"
SPACESHIP_TIME_SHOW="true"
SPACESHIP_USER_SHOW="always"
SPACESHIP_USER_COLOR="yellow"
SPACESHIP_USER_COLOR_ROOT="red"
SPACESHIP_EXIT_CODE_SHOW="true"

#sdkman
export SDKMAN_DIR=$HOME/.sdkman
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
#
