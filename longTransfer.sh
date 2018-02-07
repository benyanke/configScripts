#!/bin/bash

# Long transfer script for rsync
# Allow it to run in the background, and even if interrupted,
# it will retry again and again

# Known issue: it doesn't exit properly with CTRL + C, because this
# kills the rsync process, which returns an error and continues in the loop.

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
    rsync -azvvP -e ssh "$from" "$to" ;
    RC=$?;
    sleep 5;
done


exit 0;
