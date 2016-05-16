#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi


apt-get update
apt-get install apache2-utils -y
