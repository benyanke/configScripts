#!/bin/bash

# From https://www.howtoforge.com/tutorial/kvm-on-ubuntu-14.04/


currentUser=$(who -m | awk '{print $1;}');

mkdir /home/$currentUser/kvm/osImages -p
mkdir /home/$currentUser/kvm/vmDisks -p

# Install packages
apt update
apt install -y qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils

# Add User
adduser $currentUser libvirtd
adduser $currentUser kvm

# Setup Gui Tool
apt install -y virt-manager ssh-askpass-gnome ssh-askpass
clear;
echo ""
echo "Looks like KVM setup is complete. Try running 'sudo virt-manager' to use the gui."
