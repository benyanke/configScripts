#!/bin/bash
# Find the dconf tree for commands

# Not sure what this is
set -e

# Temp Files
old="/tmp/old-gsettings"
new="/tmp/new-gsettings"


function cleanup {
  rm -f $old
  rm -f $new
}
trap cleanup EXIT

# write old settings to file
gsettings list-recursively > $old

# make change
read -rsp $'Make the change and press any key to continue...\n' -n1 key

# write new settings to file
gsettings list-recursively > $new

# look at difference between files
diff $old $new
