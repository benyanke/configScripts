#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi


# GUI VERSION
sudo apt-add-repository -y ppa:fingerprint/fingerprint-gui
sudo apt-get update
sudo apt-get install libbsapi policykit-1-fingerprint-gui fingerprint-gui -y

nohup fingerprint-gui &

# from http://www.omgubuntu.co.uk/2013/03/how-to-get-your-fingerprint-reader-working-in-ubuntu


exit
### OR CLI VERSION

add-apt-repository -y ppa:fingerprint/fprint
apt-get update
apt-get install libfprint0 fprint-demo libpam-fprintd -y



# Then run fprintd-enroll

# from: http://askubuntu.com/questions/511876/how-to-install-a-fingerprint-reader-on-lenovo-thinkpad

