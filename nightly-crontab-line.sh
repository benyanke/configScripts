
# Nightly Updates at 1am
0 1 * * * (/usr/bin/apt-get update && /usr/bin/apt-get upgrade -q -y && /usr/bin/apt-get dist-upgrade -q -y && /usr/bin/apt-get autoremove -y) >> /var/log/apt/myupdates.log
