#!/bin/bash

# Requires wondershaper from apt

# Update me with the interface you want to limit
interface="enp0s25"

# Root check
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

if [ $# -eq 0 ] ; then
        echo "Bandwidth shaping script ";
        echo "Usage (speeds i=n mbps): ";
        echo ""
        echo "bandwidthShaper.sh [down limit] [up limit]";
elif [[ $1 == "clear" ]] ; then
        echo "Bandwidth control: no limits"
        wondershaper clear $interface
else
        up="$(($1 * 1000))"
        down="$(($2 * 1000))"

        echo "Bandwidth control: $1/$2 mbps"

        wondershaper $interface $down $up
fi
