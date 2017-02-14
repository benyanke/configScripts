#!/bin/bash

sudo apt-get update;
sudo apt-get upgrade -y;
sudo apt-get install ubuntu-desktop x11vnc -y;
sudo apt-get install build-essential -y;
sudo apt-get install ubuntu-desktop -y sudo apt-get dist-upgrade -y;
sudo apt-get autoremove -y; sudo apt-get autoremove -y; sudo apt-get autoremove -y;

sudo start lightdm

nohup /usr/sbin/lightdm &

sleep 10;

echo "Starting VNC...";

/usr/bin/x11vnc  > /dev/null 2>&1 &

sleep 7;
echo "Done! Connect to port 5900.";

wait;


echo "VNC session complete.";










