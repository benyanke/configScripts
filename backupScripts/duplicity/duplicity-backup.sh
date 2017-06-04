#!/bin/bash

# Duplicity backup script - to be called daily

# General function
function runBackup() {
  export PASSPHRASE=$3
  exclude="$4"
  to="$2"
  from="$1"
  duplicity $from $to $exclude
  duplicity verify $to $from
  unset PASSPHRASE
  unset exclude
  unset to
  unset from
}

runBackup "/home/benyanke/" "scp://ssh-remote-server/volume1/bry-home-backups/computers/by-thinkpad/nightly-home" "7f30e3652c98fbfb858d968c5dc179e27c522d30c1115345b1deee2fabc83ba5" ""
