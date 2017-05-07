#!/usr/bin/env bash

# This script runs wake on lan to wake up remote
# computer, runs command, and the shuts down the
# computer if it was off when the script began.
#
# This is useful for backups, or ensuring sometimes-off computers
# stay up to date.

mac="18:03:73:E6:EF:42"
sshHost="SSHHOST"
checkCommand="sudo uptime"
mainCommand="sudo apt update"
shutdownCommand="sudo shutdown now"

timeout 2 ssh -t "$sshHost" "$checkCommand"  >/dev/null 2>&1

if [[ $? -ne 0 ]] ; then
  isOn=0;
else
  isOn=1;
fi

if [[ $isOn == 0 ]]; then

  timeout 2 ssh -t "$sshHost" "$checkCommand"  >/dev/null 2>&1
  while [[ $? -ne 0 ]] ; do
    sudo wakeonlan "$mac"
    sleep 1
    timeout 2 ssh -t "$sshHost" "$checkCommand"  >/dev/null 2>&1
  done

fi


ssh -t "$sshHost" "$mainCommand"



# Shut down when done if it was already off
if [[ $isOn 0 ]]; then

  ssh -t "$sshHost" "$shutdownCommand"

fi

echo $isOn
