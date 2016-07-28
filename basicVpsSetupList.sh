#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root."
  exit
fi

# Set up firewall
ufw default deny incoming
ufw default allow outgoing

ufw allow 22
ufw allow 80
ufw allow 443
ufw --force enable


# Updating software
apt-get update
apt-get upgrade -y

# Installing handy tools
apt-get install git htop tree stress mc -y

clear;
echo "Run complete. Things you need to do still:";
echo "";
echo " * Setup backups"
echo " * Fail2Ban"
echo " * Add benyanke user"
echo " * Add public key(s) for benyanke"
echo " * Add to logging system"
