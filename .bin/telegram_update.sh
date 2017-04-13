#!/usr/bin/env bash

cd /tmp
rm -rf linux Telegram/
wget https://telegram.org/dl/desktop/linux
tar xf linux
if [ -f Telegram/Telegram ]; then
    cd
    rm -rf .Telegram/*
    mv /tmp/Telegram/* .Telegram/
fi

