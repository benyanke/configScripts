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
echo "Capturing current configuration before change"
gsettings list-recursively > $old

# make change
read -rsp $'Make the change and press any key to continue...\n' -n1 key

# write new settings to file
echo "Capturing current configuration after change"
gsettings list-recursively > $new

# look at difference between files
echo "Here are the settings that have changed: "
diff $old $new
