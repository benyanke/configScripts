#!/bin/bash

# from https://github.com/skilion/onedrive

# Root check
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# get current user
user=${SUDO_USER:-$(whoami)}

echo "OneOrive for Linux - One click install script"
echo ""
echo "Installing packages"

apt-get -qq update
#apt-get -qq install -y libcurl-dev 
apt-get -qq install -y libcurl3 
apt-get -qq install -y libcurl4-openssl-dev libcurl4-openssl-dev libcurl4-openssl-dev

apt-get -qq install -y libsqlite3-dev
apt-get -qq install -y make git

wget http://master.dl.sourceforge.net/project/d-apt/files/d-apt.list -O /etc/apt/sources.list.d/d-apt.list
wget -qO - http://dlang.org/d-keyring.gpg | apt-key add -

apt-get -qq update
apt-get -qq install -y dmd-bin

git clone https://github.com/skilion/onedrive /home/$user/OneDriveInstall

make -C  /home/$user/OneDriveInstall
make install -C  /home/$user/OneDriveInstall

mkdir -p /home/$user/.config/onedrive
cp /usr/local/etc/onedrive.conf /home/$user/.config/onedrive/config

echo ""
echo ""
echo "OneDrive install complete!"
echo "To continue, please go setup the full configuration in ~/.config/onedrive/config";
