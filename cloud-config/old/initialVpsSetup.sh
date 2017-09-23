#!/bin/bash

# Root check
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# get current user
#user=${SUDO_USER:-$(whoami)}
user=benyanke

adduser --disabled-password $user
usermod -aG sudo $user

log=/home/$user/setupLog

# Set up firewall
ufw default deny incoming > $log
ufw default allow outgoing >> $log

ufw allow 22 >> $log
# ufw allow 80 >> $log
# ufw allow 443 >> $log
ufw --force enable >> $log


# Updating software
apt-get update >> $log
apt-get upgrade -y >> $log
apt-get dist-upgrade -y >> $log

# Installing handy tools
apt-get install git htop tree stress mc iperf iperf3 nethogs zip unzip traceroute -y >> $log

# Setup Scripts dir and populate with a few things
mkdir -p /home/$user/scripts/ >> $log

mkdir -p /home/$user/scripts/ezservermonitor-sh/ >> $log
git clone https://github.com/benyanke/ezservermonitor-sh /home/$user/scripts/ezservermonitor-sh/ >> $log
chmod +x /home/$user/scripts/ezservermonitor-sh/*.sh >> $log

# Adding SSH Keys
keyFile="/home/$user/.ssh/authorized_keys"
mkdir -p /home/$user/.ssh/ >> $log
touch $keyFile

echo "# BY Main  Key" >> $keyFile
curl https://raw.githubusercontent.com/benyanke/PublicKeys/master/BY-43587-ssh2-PubKeyAlt.txt >> $keyFile
echo " " >> $keyFile

echo "# BY Mobile Key" >> $keyFile
curl https://raw.githubusercontent.com/benyanke/PublicKeys/master/BY-Mobile-48569-ssh2-PubKeyAlt.txt >> $keyFile
echo " " >> $keyFile

chown $user:$user /home/$user/.ssh >> $log
chown $user:$user /home/$user/.ssh/authorized_keys >> $log
chmod 600 /home/$user/.ssh/authorized_keys >> $log

# Chown full home one more time, to be sure
chown -R $user:$user /home/$user/ >> $log=

clear;
echo "Run complete. Things you need to do still:"; >> $log
echo ""; >> $log
echo " * Setup backups" >> $log
echo " * Fail2Ban" >> $log
echo " * Add to logging system" >> $log

