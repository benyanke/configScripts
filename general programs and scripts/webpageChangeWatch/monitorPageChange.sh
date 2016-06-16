#!/bin/bash

# monitor.sh - Monitors a web page for changes
# sends an email notification if the file change

USERNAME="me@gmail.com"
PASSWORD="itzasecret"
URL="http://thepage.com/that/I/want/to/monitor"

for (( ; ; )); do
    mv new.html old.html 2> /dev/null
    curl $URL -L --compressed -s > new.html
    DIFF_OUTPUT="$(diff new.html old.html)"
    if [ "0" != "${#DIFF_OUTPUT}" ]; then
		echo "Page has changed.";
        sendEmail -f $USERNAME -s smtp.gmail.com:587 \
            -xu $USERNAME -xp $PASSWORD -t $USERNAME \
            -o tls=yes -u "Web page changed" \
            -m "Visit it at $URL"
        sleep 10
    fi