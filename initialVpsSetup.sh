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
apt-get dist-upgrade -y

# Installing handy tools
apt-get install git htop tree stress mc iperf iperf3 nethogs zip unzip traceroute -y

# Setup Scripts dir and populate with a few things
mkdir -p /home/$user/scripts/

mkdir -p /home/$user/scripts/ezservermonitor-sh/
git clone https://github.com/benyanke/ezservermonitor-sh /home/$user/scripts/ezservermonitor-sh/
chmod +x /home/$user/scripts/ezservermonitor-sh/*.sh

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

# curl -sSL https://agent.digitalocean.com/install.sh | sh


# Add nightly updates to crontab
crontabTmpFile="/tmp/crontab-tmp
echo "# Nightly Updates at 3am" > $crontabTmpFile
echo "touch /var/log/apt/myupdates.log" >> $crontabTmpFile
echo "0 3 * * * (/usr/bin/apt-get update && /usr/bin/apt-get upgrade -q -y && /usr/bin/apt-get dist-upgrade -q -y && /usr/bin/apt-get autoremove -y) >> /var/log/apt/myupdates.log" > $crontabTmpFile


crontab -l | cat - $crontabTmpFile >/tmp/fullcrontab && crontab /tmp/fullcrontab
rm /tmp/fullcrontab

clear;
echo "Run complete. Things you need to do still:";
echo "";
echo " * Setup backups"
echo " * Fail2Ban"
echo " * Add to logging system"
