#!/bin/bash

set -e

BASE_DIR=$(dirname $(realpath -s $0))

./scripts/diffconfig.sh > $BASE_DIR/../openwrt-external/defconfig
