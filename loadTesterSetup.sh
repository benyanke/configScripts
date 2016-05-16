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
stopOutput() { echo $1; }

########################
# Main
########################

echo "Updating package repository" | step
apt-get update >/dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "Could not update package repository." | subStep
	exit 1
fi

echo "Downloading packages." | step
apt-get install apache2-utils -y >/dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "Packages could not be downloaded." | subStep
	exit 1
fi
