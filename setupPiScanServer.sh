#!/bin/bash

# Request sudo access - exit if failed
sudo cat /dev/null || exit 1;


sudo apt-get update
sudo apt-get install sane -y


sudo sane-find-scanner


before="RUN=no"
after="RUN=yes"
sudo sed -i -e 's/'"$before"'/'"$after"'/g' /etc/default/saned

before="# data_portrange = 10000 - 10100"
after="data_portrange = 10000 - 10100"
sudo sed -i -e 's/'"$before"'/'"$after"'/g'  /etc/sane.d/saned.conf

echo "10.10.10.0/24" | sudo tee -a /etc/sane.d/saned.conf

