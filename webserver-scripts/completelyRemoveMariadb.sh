#!/bin/bash

# https://www.londonappdeveloper.com/how-to-completely-uninstall-mariadb-from-a-debian-7-server/

service mysql stop
apt-get update
apt-get remove --purge mysql-server mysql-client mysql-common -y
apt-get autoremove -y
apt-get autoclean

apt-get --purge remove "mysql*" "mariadb*" -y

rm /etc/mysql/ -rf

rm -rf /var/lib/mysql

apt-get autoremove -y
apt-get autoclean
apt-get update




