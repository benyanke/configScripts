#!/bin/bash

# From https://www.howtoforge.com/tutorial/kvm-on-ubuntu-14.04/

# Install packages
apt update
apt install -y qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils

# Add User
adduser `id -un` libvirtd

# Setup Gui Tool
apt install -y virt-manager

clear;
echo ""
echo "Looks like KVM setup is complete. Try running 'sudo virt-manager' to use the gui."
