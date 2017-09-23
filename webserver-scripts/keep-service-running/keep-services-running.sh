#!/bin/bash

#############
# Written by Ben Yanke
# Ensures that services do not stop. Run this script with cron to restart stopped services
# Based on http://do.co/1WAUjpU
#############

# Not sure if this kills the server
# exit;

function keepRunning() {

  ps auxw | grep $1 | grep -v grep > /dev/null

  if [ $? != 0 ]
  then
        sudo /etc/init.d/$1 start >/dev/null 2>&1
        echo "Restarted $1";
  fi
}


# keepRunning apache2
# keepRunning nginx
keepRunning mysql






