#!/usr/bin/bash
which homemaker
if [ $? -eq 0  ]
then
	echo "Homemaker is already installed"
else
	wget https://foosoft.net/projects/homemaker/dl/homemaker_linux_amd64.tar.gz
	tar -zxf homemaker_linux_amd64.tar.gz
	cd homemaker_linux_amd64
	sudo mv homemaker /usr/bin/
	cd
	cd dotfiles
fi
