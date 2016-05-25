#!/bin/bash


########################
# Lighttpd installer
#
# Created by Ben Yanke
# ben@benyanke.com
#
# NOT TESTED YET
#
# Last modified 4/23/2016
########################


if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi


echo "Installing webserver";
apt-get install lighttpd -y

echo "Installing php";
apt-get install php5-common php5-cgi php5 -y >/dev/null 2>&1

echo "Enabling lighttpd to use php";
lighty-enable-mod fastcgi-php >/dev/null 2>&1

echo "Restarting server";
service lighttpd force-reload >/dev/null 2>&1

echo "Changing webdir permissions";
chown www-data:www-data /var/www >/dev/null 2>&1
chmod 775 /var/www >/dev/null 2>&1
usermod -a -G www-data pi >/dev/null 2>&1

