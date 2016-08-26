#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi


timestamp=`date --rfc-3339=seconds`
user="benyanke"
logfile="/home/$user/scripts/criticalScripts/logs/startServices.log"


function startService() {

    ps auxw | grep $1 | grep -v grep > /dev/null

    if [ $? != 0 ]
    then
      /etc/init.d/$1 start > /dev/null
      echo "[" $timestamp "]" >> $logfile
      echo "$1 was restarted." >> $logfile
      echo "" >> $logfile
    fi

}


#startService varnish

startService mysql
startService apache2
startService nginx




