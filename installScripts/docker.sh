#!/bin/bash

# Install docker

# from https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-using-the-repository

sudo apt update;
sudo apt-get install -y linux-image-extra-$(uname -r) linux-image-extra-virtual;
sudo apt-get install -y apt-transport-https  ca-certificates  curl  software-properties-common;


curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo apt-key fingerprint 0EBFCD88


sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"



sudo apt update
sudo apt install -y docker-ce


# Test with:
# sudo docker run hello-world








