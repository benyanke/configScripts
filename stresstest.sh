#!/bin/bash

site="http://example.com"
count="500" # Number of requests for each thread to make
threads="100" # number of threads
maxtime="20";

sudo cat /dev/null || exit 1;

COUNTER=0
while [  $COUNTER -lt $threads ]; do
  echo "starting thread $COUNTER"
  curl -s -H 'Cache-Control: no-cache' "$site?thread=$COUNTER&[1-$count]"  > /dev/null &
  disown;
  let COUNTER=COUNTER+1
done

# Time based kill
sleep $maxtime &
wait;
sudo killall curl;
sleep 0.5;
sudo killall curl;
sleep 0.5;
sudo killall curl;
sleep 0.5;
sudo killall curl;

echo "Stress test complete. Press enter to exit."
