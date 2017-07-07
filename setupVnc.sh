#!/bin/bash

# Run as user

# get sudo
sudo cat /dev/null || return 1;

echo "Setting up VNC";

# Install x11vnc server
sudo apt-get update > /dev/null
sudo apt-get install -y x11vnc > /dev/null

# Setup password
x11vnc -storepasswd

# Copy to global config
sudo cp ~/.vnc/passwd /etc/x11vnc.pass > /dev/null


sudo cp /etc/rc.local /etc/rc.localbk

echo "/usr/bin/x11vnc -xkb -auth /var/run/lightdm/root/:0 -noxrecord -noxfixes -noxdamage -rfbauth /etc/x11vnc.pass -forever -bg -rfbport 5900 -o /var/log/x11vnc.log  > /dev/null 2>&1" | sudo tee /etc/rc.local
echo "exit 0;" | sudo tee -a /etc/rc.local
