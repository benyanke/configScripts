#!/bin/bash

sudo apt-get update &&
sudo add-apt-repository ppa:kubuntu-ppa/backports -y &&
sudo apt-get update && sudo apt-get dist-upgrade -y &&
sudo apt-get install kubuntu-desktop -y
