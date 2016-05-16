#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

########################
# Functions
########################

step() { sed 's/^/[] /'; }
subStep() { sed 's/^/      /'; }

########################
# Main
########################
clear;

echo ;
echo "WEB LOAD TEST INSTALLER";
echo ;
echo "Tested on Ubuntu Server.";
echo ;
echo "For more information, visit:";
echo "https://github.com/benyanke";
echo ;
echo "########################"
echo ;

echo "Updating package repository" | step
apt-get update >/dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "Could not update package repository." | subStep
	exit 1
fi

echo "Installing packages." | step
apt-get install apache2-utils -y >/dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "Packages could not be downloaded." | subStep
	exit 1
fi
