#!/bin/bash


###############################
# Offsite Server Backup Script
#
# Automatically puts file on remote
# server in tar archive, then copies the
# archive to a local storage location
###############################


remoteHost="johndoe@example.com" # SSH Host
remoteBackupPath="~"
remoteTmpArchive="/tmp/temp-archive_$(date '+%s').tar.gz"
remoteTmpArchiveHash="$remoteTmpArchive.sha3"

localArchiveDestination="/mnt/somewhere/something_backup_$(date '+%y-%m-%d_%s').tar.gz"
localArchiveHashDestination="$localArchiveDestination.sha3"


##### Shouldn't need to edit below here

printf "\n\n#######################\n"
# printf "Starting backup run on $(date '+%y-%m-%d')\n"
printf "Starting backup run on $(date --rfc-822)\n"

# Create tar file
ssh -t $remoteHost "rm -f $remoteTmpArchive; touch $remoteTmpArchive; chmod 600 $remoteTmpArchive; tar -zcf $remoteTmpArchive $remoteBackupPath; sha384sum $remoteTmpArchive > $remoteTmpArchiveHash"

echo "Copying from remote server"
scp $remoteHost:$remoteTmpArchive $localArchiveDestination
scp $remoteHost:$remoteTmpArchiveHash $localArchiveHashDestination

echo "Removing from remote server"
ssh -t $remoteHost "rm -f $remoteTmpArchive"


exit;

# Add hash checking later

# Checking hash

echo $(cat $localArchiveHashDestination | awk '{print $1}') "  " $(basename $localArchiveHashDestination) | sha384sum -c && (echo "Archive has validated"; return 0;)

# echo $(cat $localArchiveHashDestination | awk '{print $1}') " $localArchiveHashDestination" | sha384sum -c
# sha384sum -c $localArchiveHashDestination && (echo "Archive has validated"; return 0;)


echo "Archive hash invalid"
