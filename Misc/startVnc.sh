#!/bin/bash

# Simpe VNC starting script for those times you don'those
# want to leave a daemon running.

echo "Starting VNC...";

/usr/bin/x11vnc  > /dev/null 2>&1 &

sleep 7;
echo "Done! Connect to port 5900.";

wait;


echo "VNC session complete.";

