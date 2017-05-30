#!/bin/bash

# From https://askubuntu.com/a/896544/474005

sudo add-apt-repository ppa:graphics-drivers/ppa -y
sudo apt update
sudo apt purge nvidia* -y
sudo apt install nvidia-381 -y
