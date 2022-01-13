#!/bin/bash

set -ex

BASE_DIR=$(dirname $(realpath -s $0))
if [ ! -e "openwrt" ]; then
	sudo apt update
	sudo apt install build-essential ccache ecj fastjar file g++ gawk \
		gettext git java-propose-classpath libelf-dev libncurses5-dev \
		libncursesw5-dev libssl-dev python python2.7-dev python3 unzip wget \
		python3-distutils python3-setuptools python3-dev rsync subversion \
		swig time xsltproc zlib1g-dev

	# Download and update the sources
	git clone https://github.com/matthew-l-weber/openwrt.git
	cd openwrt
	git pull
	git checkout v21.02.1

	mkdir -p ../dl
	ln -fs ../dl dl
	mkdir -p ../ccache
	ln -fs ../ccache .ccache
	#mkdir -p ../feeds
	#ln -s ../feeds feeds
else
	cd openwrt
fi
cp -f $BASE_DIR/../openwrt-external/defconfig .config
cp -f $BASE_DIR/../openwrt-external/feeds.conf.default .

# Update the feeds
./scripts/feeds update -a
./scripts/feeds install -a

# Configure the firmware image and the kernel
make defconfig clean
