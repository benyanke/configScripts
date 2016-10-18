#!/bin/bash

# Add root check here later

apt update
apt install bridge-utils -y



INTERFACES FILE:

# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
# auto eno1
# iface eno1 inet static
#   address 10.10.10.10
#   netmask 255.255.255.0
#   gateway 10.10.10.1
#   dns-nameservers 8.8.8.8 8.8.4.4

auto br0
iface br0 inet static
        address 10.10.10.10
        network 10.10.10.0
        netmask 255.255.255.0
        broadcast 10.10.10.255
        gateway 10.10.10.1
        dns-nameservers 8.8.8.8 4.4.4.4
        bridge_ports eno1
        bridge_stp off
        bridge_fd 0
        bridge_maxwait 0
auto eno1
iface eno1 inet static
   address 10.10.10.11
   gateway 10.10.10.1
   hwaddress ether d8:cb:8a:20:ba:d0

