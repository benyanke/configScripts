#!/bin/bash


sudo cat /dev/null || exit 1;


sudo add-apt-repository ppa:budgie-remix/ppa -y;
sudo apt update;
sudo apt install -y budgie-desktop budgie-welcome

