#!/bin/bash

set -ex

BASE_DIR=$(dirname $(realpath -s $0))

if [ "$EUID" -ne 0 ]; then
	echo "Please run as root"
	exit
fi

setup_lan() {
	# create tap interface which will be connected to OpenWrt LAN NIC
	ip tuntap add mode tap $1
	ip link set dev $1 up
	# configure interface with static ip to avoid overlapping routes
	ip addr add $2 dev $1
}

destroy_lan(){
	# cleanup, delete tap interface created earlier
	ip addr flush dev $1 || true
	ip link set dev $1 down || true
	ip tuntap del mode tap dev $1 || true
}

if [ -z "$1" ]; then
	BIN_DIR="bin/targets/x86/64-glibc/"

	if [ -e "$BIN_DIR" ]; then
		IMG_NAME=$(ls $BIN_DIR | grep combined)
	else
		echo "No build to emulate..."
		exit
	fi
else
	BIN_DIR="."
	IMG_NAME=$1
fi

LAN="openwrt-lan" 
WAN2="openwrt-wan2" 
destroy_lan $LAN
destroy_lan $WAN2
setup_lan $LAN "192.168.200.101/24"
setup_lan $WAN2 "192.168.201.101/24"

# Tested adapters
# AP
# 11b0:6368 ATECH FLASH TECHNOLOGY rtl8192cu 802.11n WLAN Adapter
#	-device usb-host,vendorid=0x11b0,productid=0x6368 \
#
# Client only?
# 148f:7601 MediaTek mt7601u 802.11b/g/n
#	-device usb-host,vendorid=0x148f,productid=0x7601 \


# Assumes using qemu built with usb support and not host pkg
#$BASE_DIR/../../qemu/bin/qemu-system-x86_64
qemu-system-x86_64 \
	-m 1G \
	-machine type=q35,accel=kvm \
	-smp 4 \
	-drive file="$BIN_DIR/$IMG_NAME",id=d0,if=none,bus=0,unit=0 \
	-device ide-hd,drive=d0,bus=ide.0 \
	-device virtio-net-pci,netdev=lan \
	-netdev tap,id=lan,ifname=$LAN,script=no,downscript=no \
	-device virtio-net-pci,netdev=wan \
	-netdev user,id=wan \
	-device virtio-net-pci,netdev=wan2 \
	-netdev tap,id=wan2,ifname=$WAN2,script=no,downscript=no \
	-nographic

destroy_lan $LAN
destroy_lan $WAN2

