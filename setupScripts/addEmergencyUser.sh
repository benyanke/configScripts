#!/bin/bash


# Root check
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Config Data
# userToSetUp="kristopherkirkland"
userToSetup="benyanke"
userToSetup="rachelyanke"
keyUrl="https://raw.githubusercontent.com/benyanke/PublicKeys/master/other-keys/KK/sos-key.pub"

# Setup user
# adduser $userToSetup

# Get home directory
homeDir=$( getent passwd "$userToSetup" | cut -d: -f6 )
authKeys="$homeDir/.ssh/authorized_keys"

echo $homeDir

mkdir $homeDir/.ssh

# Add pubkey to authorized keys for user
touch $authKeys
printf "\n\n# Emergency Recovery Key for $userToSetup" >> $authKeys
curl $keyUrl >> $authKeys
printf "\n\n" >> $authKeys


# Create pw-free sudo group
groupadd nopwsudo

# Add user to it
usermod -aG nopwsudo $userToSetup

# Give this group proper rights in /etc/sudoers




# Fix ownership on home directory
chown $userToSetup:$userToSetup $homeDir -R

# Exit gracefully
exit 0;
