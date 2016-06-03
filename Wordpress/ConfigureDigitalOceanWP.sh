#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root."
  exit
fi


WEBDIR="/var/www"

echo #############################;
echo ## Wordpress Config Script ##;
echo #############################;
echo ;
echo "Written by Ben Yanke";
echo "https://github.com/benyanke";
echo #############################;

echo "Enter sysadmin username (will have sudo /w pw permissions): ";
read NEWUSER;

echo "User add process now beginning....\n";

adduser $NEWUSER

# Add to sudoers and www-data
usermod -a -G sudo $NEWUSER
usermod -a -G www-data $NEWUSER

# Create link in user's home
ln -s  $WEBDIR /home/$NEWUSER/www

# Set proper permissions in web dir
find /var/www -type d -exec chmod 0775 {} \;
find /var/www -type f -exec chmod 0664 {} \;


# Set up firewall
ufw allow 22
ufw allow 80
ufw allow 443
ufw --force enable


# Updating software
apt-get update
apt-get upgrade -y

# Installing handy tools
apt-get install git htop tree -y

clear;
echo "Run complete. Things you need to do still:";
echo "";
echo " * Setup backups"
echo " * Secure MySql"
echo " * Install PhpMyAdmin (if applicable)"
echo " * Add public key(s) for *$NEWUSER*"
echo " * Enable .htaccess files in apache configuration"
echo " * Rename web root to the name of the domain"
echo " * Let's Encrypt (if applicable)";
