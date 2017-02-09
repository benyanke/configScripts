#!/bin/bash

# Sudo check

workingDir="/opt/guac"

apt update
apt dist-upgrade -y
apt autoremove -y
apt autoremove -y
apt autoremove -y

apt install -y \
	libcairo2-dev libjpeg62-turbo-dev \
	libpng12-dev libossp-uuid-dev \
	libavcodec-dev libavutil-dev libswscale-dev \
	libfreerdp-dev libpango1.0-dev libssh2-1-dev \
	libvncserver-dev libpulse-dev libssl-dev \
	libvorbis-dev libwebp-dev

mkdir $workingDir -p

git clone git://github.com/apache/incubator-guacamole-server.git $workingDir

cd guacamole-server/
autoreconf -fi

$workingDir/incubator-guacamole-server/configure --with-init-dir=/etc/init.d


