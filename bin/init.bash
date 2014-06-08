#!/bin/bash

set -e -u -x

sudo update-alternatives --set editor /usr/bin/vim.basic

if !(type git && type make && type hg && type g++); then
	sudo apt-get update && sudo aptitude install -y git make mercurial g++
fi
if [ ! -x /usr/lib/git-core/git-subtree ]; then
	pushd /usr/share/doc/git/contrib/subtree
	sudo make libexecdir=/usr/lib/git-core install
	popd
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

sudo apt-get install -y rbenv zlib1g-dev libssl-dev libxml2-dev libxslt-dev libreadline-dev

if [ ! -d ~/.rbenv/plugins/ruby-build ]; then
	mkdir -p ~/.rbenv/plugins
	git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
else
	pushd ~/.rbenv/plugins/ruby-build
	git pull --ff-only
	popd
fi

eval "$(rbenv init -)"
if ! rbenv versions | grep 1.9.3-p547; then
	rbenv install 1.9.3-p547
fi

if !(type fish && fish --version | fgrep 2.1.0) ; then
	declare -r fish_deb_url='http://fishshell.com/files/2.1.0/linux/Ubuntu/fish_2.1.0-1~precise_amd64.deb'
	wget --directory-prefix /tmp --continue $fish_deb_url
	sudo apt-get install -y libjs-jquery
	sudo dpkg -i /tmp/$(basename $fish_deb_url)
	sudo aptitude markauto libjs-jquery
fi
