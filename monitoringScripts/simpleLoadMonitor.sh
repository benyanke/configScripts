#!/bin/bash

to="EMAIL HERE"
serverName="SERVER NAME HERE"

trigger=0.60

rawLoad=`cat /proc/loadavg | awk '{print $1}'`

cpuCoreCount=$(cat /proc/cpuinfo | grep processor | wc -l)

load=$(echo "scale=2; $rawLoad / $cpuCoreCount" | bc -l)

response=`echo | awk -v T=$trigger -v L=$load 'BEGIN{if ( L > T){ print "greater"}}'`

if [[ $response = "greater" ]]; then

        body="Server Load Alert for Novena for our Nation"
        body="$body\n\n"

        totalmem=$(grep MemTotal /proc/meminfo | awk '{print $2}')
        freemem=$(grep MemFree /proc/meminfo | awk '{print $2}')
        availmem=$(grep MemAvailable /proc/meminfo | awk '{print $2}')


        memuse=$(free | grep Mem | awk '{print 100-(($4+$6+$7)/$2 * 100)}');

        kbMultiplier=1000000;
        totalmem=$(echo "scale=2; $totalmem / $kbMultiplier" | bc -l)
        freemem=$(echo "scale=2; $freemem / $kbMultiplier" | bc -l)


        body="$body\n##### MEMORY #####"
        body="$body\nTotal memory: $totalmem gb"
        body="$body\nFree memory: $freemem gb"
        body="$body\nMemory Use: $memuse %"
        body="$body\n"

        body="$body\nCore count: $cpuCoreCount"
        body="$body\nAdjusted load: $load"
        body="$body\nTrigger level: $trigger"

        loadPercent=$(echo "scale=0; $load * 100" | bc -l)

        echo -e "$body" | mail -s"High load on $serverName [ $loadPercent % ]" $to

        echo -e $body
else
        echo -e "Notification not sent\n\nLoad: $load\nTrigger: $trigger"
fi





