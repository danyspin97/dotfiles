#!/usr/bin/bash
./install.sh
homemaker -clobber --variant=ubuntu -task server config.toml .
