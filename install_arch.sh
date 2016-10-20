#!/usr/bin/bash
sudo pacman -Syu
git clone https://aur.archlinux.org/package-query.git
cd package-query
makepkg -si
cd ..
git clone https://aur.archlinux.org/yaourt.git
cd yaourt
makepkg -si
cd ..
wget https://foosoft.net/projects/homemaker/dl/homemaker_linux_amd64.tar.gz
tar -zxf homemaker_linux_amd64.tar.gz
cd homemaker_linux_amd64
sudo mv homemaker /usr/bin/
cd
cd dotfiles
homemaker -clobber --variant=desktop config.toml .
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisher

