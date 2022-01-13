#!/bin/bash

set -ex
VER=21.02.1
FNAME=openwrt-imagebuilder-${VER}-x86-64.Linux-x86_64.tar.xz
BASE_DIR=$(dirname $(realpath -s $0))

wget https://github.com/matthew-l-weber/openwrt-glibc-pkgs/releases/download/v${VER}/${FNAME}
tar xf ${FNAME}
mv $(tar -tf ${FNAME} | head -1 | cut -f1 -d"/") openwrt-ib
rm -rf ../${FNAME}
cd openwrt-ib
cp -f $BASE_DIR/../openwrt-external/repositories.conf .
echo "Example build..."
echo "make image PACKAGES=\"nginx-ssl kmod-rt2800-usb kmod-usb-net-smsc95xx kmod-tun\" FILES=\"$BASE_DIR/../openwrt-external/files/\""
