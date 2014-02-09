#!/bin/bash

set -e -u -x

sudo update-alternatives --set editor /usr/bin/vim.basic

if !(type git && type make); then
	sudo aptitude install -y git make
fi
git config --global color.ui auto

pushd ~/src/ubuntu-init/dotfiles
make install
popd
