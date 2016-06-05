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

echo ; 
echo ;

echo "Check to see if swap is enabled: ";
swapon -s
echo "Press any key to continue"
read dump;

"\n/swapfile   none    swap    sw    0   0" >> /etc/fstab