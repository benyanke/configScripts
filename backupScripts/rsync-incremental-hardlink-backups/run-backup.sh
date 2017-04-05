#!/bin/bash

# Root check
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Based on:
# https://www.marksanborn.net/howto/use-rsync-for-daily-weekly-and-full-monthly-backups/

# TODO: Alert admin upon backup job complete
# TODO: Error handling

# Run unmounter on script exit
trap cleanup EXIT

# Directory containing mountpoints (only need readonly)
source="/mnt/pius-server"

# Directory for backups
backup="/mnt/backup-pool/pius/snapshots"

# Things to exclude
exclude=".fuse_hidden*"

function mountremote() {

  # Mount remote directories
#  for f in $source; do
  for f in $(ls $source); do
    if [[ -d $source/$f ]]; then
        sudo mount $source/$f &
    fi
  done

  # Mounts run in parallel - wait until they're done here
  wait;
#  mount -a || return 1;

}

function unmountremote() {

  sudo umount $source/* >/dev/null 2>&1

}

function nightbk() {

  echo "STARTING NIGHTLY BACKUP";
  rsync -a -v --exclude '$exclude' --delete --recursive $source $backup/00-nightly

}



function weekbk() {
  echo "STARTING WEEKLY BACKUP";
  rsync -a -v  --exclude '$exclude' --link-dest $backup/00-nightly --delete --recursive $backup/00-nightly/* $backup/01-weekly
}

function monthbk() {
  echo "STARTING MONTHLY BACKUP";
  rsync -a -v  --exclude '$exclude' --link-dest $backup/00-nightly --delete --recursive $backup/00-nightly/* $backup/02-monthly
}

function quarterbk() {
  echo "STARTING MONTHLY BACKUP";
  rsync -a -v  --exclude '$exclude' --link-dest $backup/00-nightly --delete --recursive $backup/00-nightly/* $backup/03-quarterly
}

function yearbk() {
  echo "STARTING YEARLY BACKUP";
  rsync -a -v  --exclude '$exclude' --link-dest $backup/00-nightly --delete --recursive $backup/00-nightly/* $backup/04-yearly
}


# Finish function
function cleanup() {
  unmountremote
}


# Add more error handling here later


# Ensure network shares are mounted
mountremote

if [[ $* == *--night* ]] || [[ $* == *-n* ]] || [[ $* == *-a* ]]; then
  nightbk
elif [[ $* == *--week* ]] || [[ $* == *-w* ]] || [[ $* == *-a* ]]; then
  nightbk
  weekbk
elif [[ $* == *--month* ]] ||  [[ $* == *-m* ]] || [[ $* == *-a* ]]; then
  nightbk
  monthbk
elif [[ $* == *--quarter* ]] ||  [[ $* == *-q* ]] || [[ $* == *-a* ]]; then
  nightbk
  quarterbk
elif [[ $* == *--year* ]] ||  [[ $* == *-y* ]] || [[ $* == *-a* ]]; then
  nightbk
  yearbk
elif [[ $* == *--auto* ]]; then
  nightbk
  yearbk
else
  echo "";
  echo "ERROR: Option not specified. Run again, specifying --night, --week, --month, --quarter, --year, or --auto (auto not yet implemented)";
  exit 1;
fi



cleanup
