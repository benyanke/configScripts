#!/bin/bash


# Root check
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# get current user
user=${SUDO_USER:-$(whoami)}



echo "THIS SCRIPT IS FOR UBUNTU 16.04.1 LTS."
# Based on:
# https://docs.docker.com/engine/getstarted/step_one/

# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04

# Update packages
apt update &&
apt upgrade -y &&
apt dist-upgrade


# Prepare for docker
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" | sudo tee /etc/apt/sources.list.d/docker.list

apt update

apt-cache policy docker-engine

apt install -y docker-engine

clear;
echo "########"
echo "Status of Docker Engine:"
echo "########"
echo ""

systemctl status docker

echo "press enter to continue"
read nul

# Add current user to the docker group
usermod -aG docker $user

