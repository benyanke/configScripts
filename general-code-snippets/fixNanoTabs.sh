#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

#replace "*et tabsize *" "set tabsize 4" -- /etc/nanorc
sed -i -e 's/#set tabsize 8/set tabsize 4/g' /etc/nanorc
