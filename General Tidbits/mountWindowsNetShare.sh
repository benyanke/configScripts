
#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

apt-get install cifs-utils -y  > /dev/null 2>&1

mkdir -p /mnt/shareloc;

mount.cifs //server/share \
/mnt/shareloc \
-o user=user,\
password=pw;

ln -s /mnt /home/user/networkShares;

exit;
