#!/bin/bash

# root check goes here

dpkg -s cifs-utils >/dev/null 2>&1
if [ $? -ne 0 ]; then 
  echo "Installing cifs-utils"
  apt update >/dev/null 2>&1
  apt install -y cifs-utils >/dev/null 2>&1
fi

mountFolder() {
    echo "//$1  /mnt/by-nas/$1 cifs credentials=/home/benyanke/.smbcredentials,iocharset=utf8,sec=ntlm 0 0"
}

mountFolder "10.0.0.1/data"
