#!/bin/bash

qemu-img convert -f raw -O vmdk $1.img $1.vmdk
