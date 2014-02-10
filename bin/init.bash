#!/bin/bash

set -e -u -x

sudo update-alternatives --set editor /usr/bin/vim.basic

if !(type git && type make); then
	sudo aptitude install -y git make
fi
git config --global color.ui auto
git config --global push.default simple
git config --global credential.helper 'cache --timeout=1800'

if [ ! -d ~/src/ubuntu-init ]; then
	mkdir -p ~/src
	git clone https://github.com/d/ubuntu-init ~/src/ubuntu-init
else
	pushd ~/src/ubuntu-init
	git pull --ff-only
fi

pushd ~/src/ubuntu-init/dotfiles
make install
popd
