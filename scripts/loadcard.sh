#!/bin/bash

set -ex

sudo umount $2* || true

sudo dd if=$1 of=$2 bs=4M

sudo sync

sudo umount $2* || true
