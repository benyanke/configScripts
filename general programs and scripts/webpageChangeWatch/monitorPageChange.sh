#!/bin/bash

# monitor.sh - Monitors a web page for changes
# sends an email notification if the file change

USERNAME="me@gmail.com"
PASSWORD="itzasecret"


if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters. Please specify url."
    exit 1;
fi

URL="http://$1"
URLHASH=$(echo -n $URL | /usr/bin/md5sum | /usr/bin/awk '{print $1}')

PATH="/home/user/path/to/script"
NEWFILE="$PATH/temp/new-$URLHASH.html";
OLDFILE="$PATH/temp/old-$URLHASH.html";
LOGFILE="$PATH/log";

# /usr/bin/touch $NEWFILE
# /usr/bin/touch $OLDFILE

#DATE=$((/bin/date -u));
DATE=`/bin/date --rfc-3339=seconds`

/bin/rm $OLDFILE
/bin/mv $NEWFILE $OLDFILE
/usr/bin/curl $URL -L --compressed -s > $NEWFILE

DIFF_OUTPUT=0

OLDHASH=$(/bin/cat $NEWFILE | /usr/bin/md5sum | /usr/bin/awk '{print $1}')
NEWHASH=$(/bin/cat $OLDFILE | /usr/bin/md5sum | /usr/bin/awk '{print $1}')

echo "URL: $URL";
echo "URL Hash: $URLHASH";
echo " ";
echo "New Hash: $NEWHASH ";
echo "Old Hash: $OLDHASH ";

    if [ $NEWHASH != $OLDHASH ]; then
        /usr/bin/sendEmail -f $FROMUSERNAME -s aspmx.l.google.com:25 \
            -xu $USERNAME -xp $PASSWORD -t $USERNAME \
            -u "Web page changed for $URL!" \
            -m "Scanned URL: $URL. \nScan was completed on [$DATE]. \nCode id: 9456574398"

        echo "[$DATE] CHANGE: $URL" >> $LOGFILE
    else
        echo "[$DATE] Scan: $URL" >> $LOGFILE
    fi
