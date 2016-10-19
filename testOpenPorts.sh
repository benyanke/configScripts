#!/bin/bash

host=scanme.nmap.org

# Scan regular
nmap -PN $host

# scan every port
# sudo nmap -n -PN -sT -sU -p- $host

