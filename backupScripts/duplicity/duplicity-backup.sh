#!/bin/bash

# Duplicity backup script - to be called daily

# General function
function runBackup() {
  export PASSPHRASE=$3
  duplicity $1 $2
  unset PASSPHRASE
}

runBackup "~/" "scp://ssh-remote-server/path/on/remote" "backup-password"
