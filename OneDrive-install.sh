#!/bin/bash

# from https://github.com/skilion/onedrive

# Root check
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# get current user
user=${SUDO_USER:-$(whoami)}

apt-get update
apt-get install -y libcurl-dev 
apt-get install -y libcurl3 
apt-get install -y libsqlite3-dev
wget http://master.dl.sourceforge.net/project/d-apt/files/d-apt.list -O /etc/apt/sources.list.d/d-apt.list
wget -qO - http://dlang.org/d-keyring.gpg | apt-key add -
apt-get update && sudo apt-get install dmd-bin

make
sudo make install

mkdir -p /home/$user/.config/onedrive
cp /usr/local/etc/onedrive.conf /home/$user/.config/onedrive/config

echo ""
echo ""
echo "OneDrive install complete!"
echo "To continue, please go setup the full configuration in ~/.config/onedrive/config";
