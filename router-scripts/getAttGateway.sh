#!/bin/bash


ip=$(curl http://192.168.10.254/cgi-bin/broadbandstatistics.ha | grep "Broadband IPv4 Address" -A 2 | head -n 2 | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")

echo $ip;
