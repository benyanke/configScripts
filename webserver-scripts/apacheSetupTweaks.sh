#!/bin/bash

# todo:
# set proper permissions in web directory
# add link to home for www

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Set vars
USER=benyanke
WEBDIR=/var/www

# Set proper permissions
adduser $USER www-data
chown $USER:www-data -R $WEBDIR
chmod u=rwX,g=rwX,o=rX -R $WEBDIR

# Add link to home directory
ln -s  $WEBDIR /home/$USER/www
