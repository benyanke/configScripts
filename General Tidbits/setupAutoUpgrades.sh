#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

crontab -l | { cat; echo "#auto upgrades\n0 0 * * * apt-get update && apt-get -y upgrade >/dev/null 2>&1\n"; } | crontab -

echo "Successfully added auto updates to run nightly";
