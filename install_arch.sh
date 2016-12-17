#!/usr/bin/bash
sudo pacman -Syu
./install.sh
homemaker -clobber --variant=desktop config.toml .
