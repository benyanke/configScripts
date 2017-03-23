#!/bin/bash

# Base path on local server
basepath="/mnt/backups"

function getbackups() {

        localpath="$basepath/$1"
        remotepath="$2"
        remoteserver="$3" # ssh host


        from="$remoteserver:$remotepath"
        to="$localpath/"

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


}

#getbackups "local path" "remotepath" "ssh host"

getbackups "server1" "/var/www/backups" "john@example.com"
getbackups "server2" "/var/www/backup-dir" "john@example.org"
