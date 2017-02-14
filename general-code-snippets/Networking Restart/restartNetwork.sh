#!/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games

# Set this to run frequently in my virtualbox VMs where networking occasionally goes down
# Restarts networking when it goes down

## Add this to crontab (SUDO)
## * * * * * /bin/bash /home/benyanke/scripts/restartNetwork.sh >/dev/null 2>&1

if [ "$EUID" -ne 0 ]
  then echo "Please run as root."
  exit
fi


ping -q -w 1 -c 1 `ip r | grep default | cut -d ' ' -f 3` > /dev/null && echo "ok" > /dev/null || ifdown eth0 && ifup eth0
