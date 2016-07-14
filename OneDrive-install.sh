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
apt-get install -y libcurl4-openssl-dev libcurl4-gnutls-dev
apt-get install -y libsqlite3-dev
apt-get install -y make
apt-get install -y git

wget http://master.dl.sourceforge.net/project/d-apt/files/d-apt.list -O /etc/apt/sources.list.d/d-apt.list
wget -qO - http://dlang.org/d-keyring.gpg | apt-key add -

apt-get update
apt-get install -y dmd-bin

git clone https://github.com/skilion/onedrive /home/$user/OneDriveInstall

exit

make -C  /home/$user/OneDriveInstall
make install -C  /home/$user/OneDriveInstall

mkdir -p /home/$user/.config/onedrive
cp /usr/local/etc/onedrive.conf /home/$user/.config/onedrive/config

echo ""
echo ""
echo "OneDrive install complete!"
echo "To continue, please go setup the full configuration in ~/.config/onedrive/config";
