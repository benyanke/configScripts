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


apt-get update | stopOutput
if [ $? -ne 0 ]; then
	echo "Could not update packages." | subStep
	exit 1
fi

apt-get install apache2-utils -y | stopOutput
if [ $? -ne 0 ]; then
	echo "Packages could not be downloaded." | subStep
	exit 1
fi
