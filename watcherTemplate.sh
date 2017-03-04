#!/bin/bash

size=0;

printf "Size watcher\n\n"

while :
do
        hrSize=$(du -h tmp/*.tar.gz | awk '{print $1}')
        rawSize=$(du tmp/*.tar.gz | awk '{print $1}')

        echo -en "\e[1A"
        printf "$hrSize / $rawSize bytes\n"

#       sleep 10;
        sleep 0.5;
done



