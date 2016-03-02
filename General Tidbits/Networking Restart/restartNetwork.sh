#!/bin/bash

#Set this to run frequently
#Restarts networking when it goes down

## Add this to crontab (SUDO)
## * * * * * /bin/bash /home/benyanke/scripts/restartNetwork.sh >/dev/null 2>&1

if [ "$EUID" -ne 0 ]
  then echo "Please run as root."
  exit
fi


#ping -c 2 8.8.8.8 > /dev/null && echo "up" > /dev/null || ifdown eth0 && ifup eth0

ping -q -w 1 -c 1 `ip r | grep default | cut -d ' ' -f 3` > /dev/null && echo "ok" > /dev/null || ifdown eth0 && ifup eth0