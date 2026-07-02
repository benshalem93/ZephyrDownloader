#!/bin/bash

west init --mr v4.4.0 zephyrproject
cd zephyrproject
west update

west blobs fetch hal_espressif
west blobs fetch hal_stm32

find . -name \.git|xargs rm -rf

cd ..
mkdir -p /artifacts/pip/requirements1
cp ./zephyrproject/zephyr/scripts/requirements* /artifacts/pip/requirements1/
mkdir -p /artifacts/pip/requirements2
cp ./zephyrproject/bootloader/mcuboot/scripts/requirements* /artifacts/pip/requirements2/
mkdir -p /artifacts/pip/requirements3
cp ./zephyrproject/modules/hal/espressif/zephyr/requirements.txt /artifacts/pip/requirements3/

tar -cf - zephyrproject/ -P | pv -s $(du -sb zephyrproject/ | awk '{print $1}') | bzip2 -c > /artifacts/zephyrproject.tar.bz2
