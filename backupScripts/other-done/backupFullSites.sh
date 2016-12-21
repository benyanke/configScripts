#!/bin/bash


# For file name of archive
DATE=`date +%Y-%m-%d`; 

backupName="fullSiteBackup"

# base path where to store archives
archiveStorePath="/backup/location"

# Web server root
webRoot="/path/to/public_html"

echo "##############################";
timestamp=`date --rfc-3339=seconds`

echo "[$timestamp]";


/bin/tar -cvzf	\
		"$archiveStorePath"/caladv_"$backupName"_"$DATE".tar.gz "$webRoot"/* \
		--exclude="$webRoot/newyork" \
		--exclude="$webRoot/florida" \
		--exclude="$webRoot/5-29-2013" \
		--exclude="$webRoot/SouthBayFord" \
		--exclude="$webRoot/old-site" \
		--exclude="$webRoot/oldsite"  \
		--exclude="$webRoot/*.zip"  \
		--exclude="$webRoot/*.gz"  \
		--exclude="$webRoot/*tar.gz"  > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "[PASS] CalAdv theme backup"
else
    echo "[FAIL] CalAdv theme backup"
fi

echo ; 

/bin/tar -cvzf \
		"$archiveStorePath"/aif_"$backupName"_"$DATE".tar.gz \
		"$webRoot"/florida/*  > /dev/null 2>&1


if [ $? -eq 0 ]; then
    echo "[PASS] Aif theme backup"
else
    echo "[FAIL] Aif theme backup"
fi


