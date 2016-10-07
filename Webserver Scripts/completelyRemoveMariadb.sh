#!/bin/bash

# https://www.londonappdeveloper.com/how-to-completely-uninstall-mariadb-from-a-debian-7-server/

service mysql stop
apt-get update
apt-get remove --purge mysql-server mysql-client mysql-common
apt-get autoremove
apt-get autoclean

apt-get --purge remove "mysql*" "mariadb*" -y
mv /etc/mysql/ /tmp/mysql_configs/

rm -rf /var/lib/mysql

