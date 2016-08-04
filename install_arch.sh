#!/usr/bin/bash
sudo pacman -Syu
sudo pacman -S yaourt git --noconfirm
wget https://foosoft.net/projects/homemaker/dl/homemaker_linux_amd64.tar.gz
tar -zxf homemaker_linux_amd64.tar.gz
cd homemaker_linux_amd64
sudo mv homemaker /usr/bin/
cd
cd dotfiles
homemaker -clobber --variant=desktop config.toml .
