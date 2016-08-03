#!/usr/bin/bash
cd
wget https://foosoft.net/projects/homemaker/dl/homemaker_linux_amd64.tar.gz
tar -zxf homemaker_linux_amd64.tar.gz
cd homemaker_linux_amd64
sudo mv homemaker /usr/bin/
cd
git clone https://gitlab.com/danyspin97/dotfiles
cd dotfiles
homemaker -clobber --variant=desktop config.toml .
