#!/bin/bash

# From https://www.howtoforge.com/tutorial/kvm-on-ubuntu-14.04/


currentUser=$(who -m | awk '{print $1;}');

# Install packages
apt update
apt install -y qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils

# Add User
adduser $currentUser libvirtd
adduser $currentUser kvm

# Setup Gui Tool
apt install -y virt-manager

clear;
echo ""
echo "Looks like KVM setup is complete. Try running 'sudo virt-manager' to use the gui."
