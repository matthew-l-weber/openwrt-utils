#!/bin/bash

set -e

VER=21.02.1
BASE_DIR=$(dirname $(realpath -s $0))

if [ ! -e "../openwrt-glibc-pkgs" ]; then
	pushd ../
	git clone git@github.com:matthew-l-weber/openwrt-glibc-pkgs.git
	popd
fi
git -C ../openwrt-glibc-pkgs pull
cp bin/* ../openwrt-glibc-pkgs/21.02.1/ -a
git -C ../openwrt-glibc-pkgs add -A
git -C ../openwrt-glibc-pkgs status
echo "git -C ../openwrt-glibc-pkgs commit -m \"updated $VER archives\""
echo "git -C ../openwrt-glibc-pkgs push origin"
