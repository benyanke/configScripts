#!/bin/bash

# Long transfer script for rsync
# Allow it to run in the background, and even if interrupted, it will retry again and again

# Example:
from="john@example.com:/var/bigfile/file.tar.gz"
to="/home/johndoe/filedump/"


########################
# Don't edit below here
########################


# Initial Try
rsync -azvvP -e ssh "$from" "$to" ;
RC=$?

while [[ $RC -ne 0 ]]; do
    # Retry
    sleep 5;
    rsync -azvvP -e ssh "$from" "$to" ;
    RC=$?
done


exit 0;
