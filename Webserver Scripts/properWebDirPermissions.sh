#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi


USER=benyanke
sudo adduser $USER www-data
sudo chown $USER:www-data -R /var/www
#sudo chmod u=rwX,g=srX,o=rX -R /var/www
sudo chmod 664 -R /var/www
