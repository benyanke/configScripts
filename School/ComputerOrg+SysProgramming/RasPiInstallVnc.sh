#!/bin/bash

# Install's vnc on a raspberry pi
# TODO: Need to find full path for the VNC

# Check if script is running as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root (preface your command with 'sudo')"
  exit 1
fi

# Check if internet access is present
wget -q --tries=10 --timeout=20 --spider http://google.com
if [[ $? -eq 0 ]]; then
	echo "Installing VNC now....";
else
	echo "You are offline. Please connect to internet before continuing."
	exit 1
fi



# update apt-get's local package list
apt-get update >/dev/null 2>&1

#install the VNC server
apt-get install x11vnc -y  >/dev/null 2>&1

#setup server with password
echo "You will now be asked for a password for your VNC server. Please write it down!"
x11vnc -storepasswd


mkdir -p /home/pi/.config/autostart
touch /home/pi/.config/autostart/x11vnc.desktop

echo "[Desktop Entry]" > /home/pi/.config/autostart/x11vnc.desktop
echo "Encoding=UTF-8" >> /home/pi/.config/autostart/x11vnc.desktop
echo "Type=Application" >> /home/pi/.config/autostart/x11vnc.desktop
echo "Name=X11VNC" >> /home/pi/.config/autostart/x11vnc.desktop
echo "Comment=" >> /home/pi/.config/autostart/x11vnc.desktop
echo "Exec=x11vnc -forever -usepw -display :0 -ultrafilexfer" >> /home/pi/.config/autostart/x11vnc.desktop
echo "StartupNotify=false" >> /home/pi/.config/autostart/x11vnc.desktop
echo "Terminal=false" >> /home/pi/.config/autostart/x11vnc.desktop
echo "Hidden=false" >> /home/pi/.config/autostart/x11vnc.desktop

echo "Set up successfully. Your IP is:"
ifconfig | perl -nle 's/dr:(\S+)/print $1/e'

# - sudo apt-get install x11vnc
# - x11vnc -storepasswd

# create autostart entry

# - cd .config
# - mkdir autostart
# - cd autostart
# - nano x11vnc.desktop
# - paste following text:

# [Desktop Entry]
# Encoding=UTF-8
# Type=Application
# Name=X11VNC
# Comment=
# Exec=x11vnc -forever -usepw -display :0 -ultrafilexfer
# StartupNotify=false
# Terminal=false
# Hidden=false