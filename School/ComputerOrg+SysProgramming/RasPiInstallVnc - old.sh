#!/bin/bash

# Install's TightVNC on a raspberry pi
# TODO: Need to find full path for tightVNC

# Check if script is running as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root (preface your command with 'sudo')"
  exit 1
fi

# Check if internet access is present
wget -q --tries=10 --timeout=20 --spider http://google.com
if [[ $? -eq 0 ]]; then
	# Do nothing! Connected to the internet successfully
else
	echo "You are offline. Please connect to internet before continuing."
	exit 1
fi

echo "Installing VNC now....";

# update apt-get's local package list
apt-get update >/dev/null 2>&1

#install the VNC server
apt-get install tightvncserver -y  >/dev/null 2>&1

#allow the user to configure the server now
tightvncserver

#start server once it's configed
vncserver :1 -geometry 800x600 -depth 24

