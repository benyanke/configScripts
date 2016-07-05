#!/bin/bash



add-apt-repository -y ppa:fingerprint/fprint
apt-get update
apt-get install libfprint0 fprint-demo libpam-fprintd -y


# Then run fprintd-enroll

# from: http://askubuntu.com/questions/511876/how-to-install-a-fingerprint-reader-on-lenovo-thinkpad
