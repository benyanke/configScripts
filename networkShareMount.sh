#!/bin/bash

# root check goes here

dpkg -s cifs-utils >/dev/null 2>&1
if [ $? -ne 0 ]; then 
  echo "Installing cifs-utils"
  apt update >/dev/null 2>&1
  apt install -y cifs-utils >/dev/null 2>&1
fi

basepath="/mnt/by-nas"

function mountFolder() {
  echo "//10.10.10.9/$0 /mnt/by-nas/$1 cifs credentials=/home/benyanke/.smbcredentials,iocharset=utf8,sec=ntlm 0 0"
}


# NOT FINISHED YET
