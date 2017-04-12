#!/bin/bash

site="http://example.com"
count="500" # Number of requests for each thread to make
threads="10" # number of threads

COUNTER=0
while [  $COUNTER -lt $threads ]; do
  echo "starting thread $COUNTER"
  curl -s -H 'Cache-Control: no-cache' "$site?thread=$COUNTER&[1-$count]"  > /dev/null &
  let COUNTER=COUNTER+1
done


wait;
echo "Stress test complete. Press enter to exit."
