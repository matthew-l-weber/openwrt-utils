# openwrt-utils
Repository for scripts related to building, testing and deploying openwrt

## Qemu build notes for usb pass-through support

https://wiki.qemu.org/Hosts/Linux#Simple_build_and_test
```
git clone git://git.qemu-project.org/qemu.git
cd qemu/
mkdir -p bin/
cd bin/
sudo apt install ninja-build libusbredirparser-dev libusb-dev
../configure --target-list=x86_64-softmmu
make -j4
```
