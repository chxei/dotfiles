#!/bin/bash

#post-setup
qdbus org.kde.KWin /KWin reconfigure;
konsole -e kquitapp5 plasmashell && kstart5 plasmashell --windowclass plasmashell --window Desktop;
plasmashell --replace > /dev/null 2>&1 & disown;
gio trash -f temp;
sudo systemctl restart display-manager;