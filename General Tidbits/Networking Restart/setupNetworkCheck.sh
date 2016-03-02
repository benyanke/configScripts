#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi


mkdir "/home/benyanke/scripts";
touch "/home/benyanke/scripts/restartNetwork.sh"

wget "https://raw.githubusercontent.com/benyanke/configScripts/master/General%20Tidbits/Networking%20Restart/restartNetwork.sh"  -O "/home/benyanke/scripts/restartNetwork.sh"

crontab -l | { cat; echo "* * * * * /bin/bash /home/benyanke/scripts/restartNetwork.sh >/dev/null 2>&1"; } | crontab -

echo "Successfully added network checker and scheduled to run every minute";
