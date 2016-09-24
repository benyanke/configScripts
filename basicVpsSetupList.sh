#!/bin/bash

# Root check
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# get current user
user=${SUDO_USER:-$(whoami)}


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
apt-get install git htop tree stress mc iperf iperf3 nethogs zip unzip -y

# Setup Scripts dir and populate with a few things
mkdir -p /home/$user/scripts/

mkdir -p /home/$user/ezservermonitor-sh/
git clone https://github.com/benyanke/ezservermonitor-sh /home/$user/ezservermonitor-sh/

# Adding SSH Keys
keyFile="/home/$user/.ssh/authorized_keys"
mkdir -p /home/$user/.ssh/
touch $keyFile

echo "# BY Main  Key" >> $keyFile
curl https://raw.githubusercontent.com/benyanke/PublicKeys/master/BY-43587-ssh2-PubKeyAlt.txt >> $keyFile
echo " " >> $keyFile

echo "# BY Mobile Key" >> $keyFile
curl https://raw.githubusercontent.com/benyanke/PublicKeys/master/BY-Mobile-48569-ssh2-PubKeyAlt.txt >> $keyFile
echo " " >> $keyFile

chown $user:$user /home/$user/.ssh
chown $user:$user /home/$user/.ssh/authorized_keys
chmod 600 /home/$user/.ssh/authorized_keys

# Chown full home one more time, to be sure
chown -R $user:$user /home/$user/

clear;
echo "Run complete. Things you need to do still:";
echo "";
echo " * Setup backups"
echo " * Fail2Ban"
echo " * Add to logging system"
