#!/bin/bash

west init --mr v4.4.0 zephyrproject
cd zephyrproject
west update

# Add logging functions because error 'AttributeError: 'Blobs' object has no attribute 'dbg'' (for example) is received
# sed -i '/^class /a\ \ \ \ def dbg(self, msg):\n\ \ \ \ \ \ \ \ print(msg)' /zephyrproject/zephyr/scripts/west_commands/blobs.py 
# sed -i '/^class /a\ \ \ \ def inf(self, msg):\n\ \ \ \ \ \ \ \ print(msg)' /zephyrproject/zephyr/scripts/west_commands/blobs.py 
# sed -i '/^class /a\ \ \ \ def wrn(self, msg):\n\ \ \ \ \ \ \ \ print(msg)' /zephyrproject/zephyr/scripts/west_commands/blobs.py 
# sed -i '/^class /a\ \ \ \ def err(self, msg):\n\ \ \ \ \ \ \ \ print(msg)' /zephyrproject/zephyr/scripts/west_commands/blobs.py 
west blobs fetch hal_espressif
west blobs fetch hal_stm32

# Remove the functions bacuase they create an "TypeError: Blobs.dbg() got an unexpected keyword argument 'level'" later when compiling
# sed -i '/^\ \ \ \ def dbg(self, msg):$/{N; /^\ \ \ \ def dbg(self, msg):\n\ \ \ \ \ \ \ \ print(msg)$/d;}' /zephyrproject/zephyr/scripts/west_commands/blobs.py
# sed -i '/^\ \ \ \ def inf(self, msg):$/{N; /^\ \ \ \ def inf(self, msg):\n\ \ \ \ \ \ \ \ print(msg)$/d;}' /zephyrproject/zephyr/scripts/west_commands/blobs.py
# sed -i '/^\ \ \ \ def wrn(self, msg):$/{N; /^\ \ \ \ def wrn(self, msg):\n\ \ \ \ \ \ \ \ print(msg)$/d;}' /zephyrproject/zephyr/scripts/west_commands/blobs.py
# sed -i '/^\ \ \ \ def err(self, msg):$/{N; /^\ \ \ \ def err(self, msg):\n\ \ \ \ \ \ \ \ print(msg)$/d;}' /zephyrproject/zephyr/scripts/west_commands/blobs.py

find . -name \.git|xargs rm -rf

cd ..
mkdir -p /artifacts/pip/requirements1
cp ./zephyrproject/zephyr/scripts/requirements* /artifacts/pip/requirements1/
mkdir -p /artifacts/pip/requirements2
cp ./zephyrproject/bootloader/mcuboot/scripts/requirements* /artifacts/pip/requirements2/
mkdir -p /artifacts/pip/requirements3
cp ./zephyrproject/modules/hal/espressif/zephyr/requirements.txt /artifacts/pip/requirements3/

tar -cf - zephyrproject/ -P | pv -s $(du -sb zephyrproject/ | awk '{print $1}') | bzip2 -c > /artifacts/zephyrproject.tar.bz2
