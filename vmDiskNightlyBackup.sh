#!/bin/bash

########################################
#
# VM Disk Backup Script
#
# Runs nightly, copies vm drive images
# to a nas.
#
########################################


# Run first:
# sudo apt-get install cifs-utils


# ADD ROOT CHECK HERE

rootPath="/home/benyanke/kvm"
sourcePath="$rootPath/vmDisks"
mountPoint="$rootPath/backupMounts"

# Fill in remote server info here:
hostname=""
share=""
pathWithinShare=""

# Fill in creds here
u=""
pw=""



# Mount Remote Filesystem
mount -t cifs -o username=$u,password=$pw //$hostname/$share $mountPoint


# Make backup dir if it doesn't exist
mkdir $mountPoint/$pathWithinShare -p
rm $mountPoint/$pathWithinShare/*

# Copy Backups
rsync -a --stats --progress $sourcePath $mountPoint/$pathWithinShare/


# Unmount Remote Filesystem
umount $mountPoint -f






