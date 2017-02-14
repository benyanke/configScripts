#!/bin/bash


if [ "$EUID" -ne 0 ]
  then echo "Please run as root."
  exit
fi

# 0 0 * * * apt-get update && apt-get -y upgrade >/dev/null 2>&1