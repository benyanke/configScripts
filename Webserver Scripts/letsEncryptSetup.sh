#!/bin/bash

#Pass domain name through as param
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi


echo "Running let's encrypt now...please wait";
echo "What domain should we use for this cert?";
read domain;

apt-get update >> /dev/null 2>&1;
apt-get upgrade >> /dev/null 2>&1;
apt-get install git -y >> /dev/null 2>&1;
git clone https://github.com/letsencrypt/letsencrypt /opt/letsencrypt >> /dev/null 2>&1;
cd /opt/letsencrypt;

./letsencrypt-auto --apache -d $domain;

clear;
echo "Setting up auto-renewal";

#auto renewal
sudo curl -L -o /usr/local/sbin/le-renew https://gist.githubusercontent.com/benyanke/3162eecd17c859c59f88/raw/145a3544d33f71162a555981cb512c5d33707442/le-renew.sh >> /dev/null 2>&1;
sudo chmod +x /usr/local/sbin/le-renew >> /dev/null 2>&1;


#write out current crontab
crontab -l > mycron
#echo new cron into cron file
echo "30 2 * * * /usr/local/sbin/le-renew $1 >> /var/log/le-renew.log" >> mycron
#install new cron file
crontab mycron
rm mycron


#to update:
#cd /opt/letsencrypt
#sudo git pull