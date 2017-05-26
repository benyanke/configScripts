#!/bin/bash

sudo apt-get update; sudo apt-get --purge remove freerdp-x11 remmina remmina-common remmina-plugin-rdp remmina-plugin-vnc remmina-plugin-gnome remmina-plugin-nx remmina-plugin-telepathy remmina-plugin-xdmcp -y ; sudo apt-get --purge remove libfreerdp-dev libfreerdp-plugins-standard libfreerdp1 libfreerdp-utils1.1 libfreerdp-primitives1.1 libfreerdp-locale1.1 libfreerdp-gdi1.1 libfreerdp-crypto1.1 libfreerdp-core1.1 libfreerdp-common1.1.0 libfreerdp-codec1.1 libfreerdp-client1.1 libfreerdp-cache1.1 -y ; sudo apt-get --purge remove  libfreerdp-rail1.1 libwinpr-asn1-0.1 libwinpr-bcrypt0.1 libwinpr-credentials0.1 libwinpr-credui0.1  libwinpr-crt0.1 libwinpr-crypto0.1 libwinpr-dev libwinpr-dsparse0.1 libwinpr-environment0.1  libwinpr-error0.1 libwinpr-file0.1 libwinpr-handle0.1 libwinpr-heap0.1 libwinpr-input0.1  libwinpr-interlocked0.1 libwinpr-io0.1 libwinpr-library0.1 libwinpr-path0.1 libwinpr-pipe0.1  libwinpr-pool0.1 libwinpr-registry0.1 libwinpr-rpc0.1 libwinpr-sspi0.1 libwinpr-sspicli0.1  libwinpr-synch0.1 libwinpr-sysinfo0.1 libwinpr-thread0.1 libwinpr-timezone0.1 libwinpr-utils0.1  libwinpr-winhttp0.1 libwinpr-winsock0.1 -y;  repeat 5 "aptu"; sudo apt-add-repository ppa:remmina-ppa-team/remmina-next ; sudo apt-get update ; sudo apt-get install remmina remmina-plugin-rdp libfreerdp-plugins-standard -y ; repeat 5 "aptu";

