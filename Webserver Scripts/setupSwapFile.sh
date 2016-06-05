#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Default size in gb
swapFileSize="4G"
clear;
echo "Creating empty swap file at $swapFileSize:"

fallocate -l $swapFileSize /swapfile

# set proper permissions
chmod 600 /swapfile

# make swap file
mkswap /swapfile
swapon /swapfile

echo ; 
echo ;

echo "Check to see if swap is enabled: ";
swapon -s
echo "Press any key to continue"
read dump;

echo "/swapfile   none    swap    sw    0   0" >> /etc/fstab

# turn down swappiness
sysctl vm.swappiness=5
echo " " >> /etc/sysctl.conf
echo "vm.swappiness=5" >> /etc/sysctl.conf

# turn down the cache pressure
sysctl vm.vfs_cache_pressure=50
echo " " >> /etc/sysctl.conf
echo "vm.vfs_cache_pressure = 50" >> /etc/sysctl.conf