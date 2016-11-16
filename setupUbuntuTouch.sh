#1/bin/bash

sudo apt update
sudo apt install ubuntu-emulator -y
sudo ubuntu-emulator create --arch=i386 UbuntuTouch
ubuntu-emulator run UbuntuTouch
