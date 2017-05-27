#!/bin/bash

sudo add-apt-repository ppa:gnome3-team/gnome3-staging -y &&

sudo add-apt-repository ppa:gnome3-team/gnome3 -y &&

sudo apt update &&

sudo apt dist-upgrade -y &&

sudo apt install gnome gnome-shell -y &&

clear && echo "complete" && exit;

echo "Could not be set up successfully"
