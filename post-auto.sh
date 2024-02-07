#!/bin/sh

git clone https://github.com/speyll/dotfiles
rsync ~/dotfiles/* ~/
rm -rf README.md
rm -rf LICENSE
rm -rf .git
chmod +x ~/.local/bin/*
chmod +x ~/.local/share/applications/*
chmod +x ~/.config/sway/start-bar.sh
chmod +x ~/.config/sway/start-pipewire.sh
chmod +x ~/.config/yambar/sway-switch-keyboard.sh
chmod +x ~/.config/yambar/xkb-layout.sh
ln -s ~/.config/mimeapps.list ~/.local/share/applications/