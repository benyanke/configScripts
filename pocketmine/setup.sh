#!/bin/bash

sudo apt update
sudo apt install -y perl gcc g++ make automake libtool autoconf m4 gcc-multilib
sudo apt dist-upgrade -y
sudo apt autoremove -y
sudo apt autoremove -y
sudo apt autoremove -y

curl https://raw.githubusercontent.com/PocketMine/php-build-scripts/master/installer.sh | bash
