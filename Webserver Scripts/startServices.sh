#!/bin/sh

timestamp=`date --rfc-3339=seconds`
user="benyanke"

ps auxw | grep mysql | grep -v grep > /dev/null

if [ $? != 0 ]
then
  /etc/init.d/mysql start > /dev/null
  echo "[" $timestamp "]" >> /home/$user/scripts/logs/startServices.log
  echo "MySql was restarted." >> /home/$user/scripts/logs/startServices.log
  echo "" >> /home/$user/scripts/logs/startServices.log
fi


ps auxw | grep apache2 | grep -v grep > /dev/null

if [ $? != 0 ]
then
  /etc/init.d/apache2 start > /dev/null
  echo "[" $timestamp "]" >> /home/$user/scripts/logs/startServices.log
  echo "Apache was restarted." >> /home/$user/scripts/logs/startServices.log
  echo "" >> /home/$user/scripts/logs/startServices.log
fi



