#!/bin/bash

# Request sudo access - exit if failed
sudo cat /dev/null || exit 1;


sudo apt-get update
sudo apt-get install sane -y


sudo sane-find-scanner
