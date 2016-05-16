#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

########################
# Functions and Variables
########################

step() { sed 's/^/[] /'; }
subStep() { sed 's/^/      /'; }

# Username to run tests under
testUser="loadtest1"

########################
# Main
########################
clear;

# Based on:
# https://www.digitalocean.com/community/tutorials/how-to-use-apachebench-to-do-load-testing-on-an-ubuntu-13-10-vps

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


echo "Creating user for testing." | step

getent passwd testUser  > /dev/null
if [ $? -eq 0 ]; then
	# User already exists
    echo "User already exists. Use another user for testing." | subStep
    exit 1
fi


useradd -m -d /home/$testUser -s /bin/bash -g sudo $testUser  >/dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "User could not be created." | subStep
	exit 1
fi
