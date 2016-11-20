#!/bin/bash

#sudo apt-get remove -y lamp-server^

sudo apt-get update >> /dev/null 2>&1 && 
echo "Apt update complete" &&

sudo apt-get upgrade -y >> /dev/null 2>&1 && 
echo "Full Software upgrade complete" &&

sudo apt-get install apache2 -y >> /dev/null 2>&1 && 
echo "Apache installed" &&

sudo apt-get install php5 libapache2-mod-php5 -y >> /dev/null 2>&1 &&  
echo "php installed" &&

sudo /etc/init.d/apache2 restart >> /dev/null 2>&1 && 
echo "Apache restarted" && 

echo "Complete" && 
exit;

echo "error";
