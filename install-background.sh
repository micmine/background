#!/bin/bash
sudo apt install dmenu feh

mkdir -p ~/.scripts
cp background.sh ~/.scripts/background.sh
sudo chmod 755 ~/.scripts/background.sh
sudo ln -s ~/.scripts/background.sh /usr/local/bin/background

mkdir -p ~/Wallpapers/
cp config/Wallpapers/* ~/Wallpapers/
