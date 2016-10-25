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

echo "#########################"
echo "#### SETTINGS DIGGER ####"
echo "#########################"
echo "Find the link between options in GUI and gsettings"
echo ""

# write old settings to file
gsettings list-recursively > $old

# make change
read -rsp $'Make the change you want to detect and press any key to continue...\n' -n1 key

# write new settings to file
gsettings list-recursively > $new

# look at difference between files
echo ""
echo "Here are the settings that have changed: "
echo ""
diff $old $new
