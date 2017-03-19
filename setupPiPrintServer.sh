#!/bin/bash

printuser="benyanke";


sudo cat /dev/null || exit 1;

sudo apt-get update;
sudo apt-get install cups -y;

sudo usermod -aG lpadmin $printuser;

# Set to listen on external port
before="Listen localhost:631"
after="Port 631"
sudo sed -i -e 's/'"$before"'/'"$after"'/g' /etc/cups/cupsd.conf


before="Order allow,deny"
after="Order allow,deny\nAllow @local"
sudo sed -i -e 's/'"$before"'/'"$after"'/g' /etc/cups/cupsd.conf

# Restart
sudo /etc/init.d/cups restart


echo "Cups should now be set up!"
