#!/bin/bash

key="PATH TO KEY"
remotePort="8022"
connection="revssh@HOSTNAME"

autossh -M 0 -T \
	-o "ServerAliveInterval 30" \
	-o "ServerAliveCountMax 3" \
	-R *:$remotePort:localhost:22 -i $key $connection &

