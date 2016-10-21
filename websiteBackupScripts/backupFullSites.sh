
#!/bin/bash

# base path where to store archives
archiveStorePath="/var/www/backups/filesystemBackups"

# Web server root
webRoot="/var/www/html"

# Log location
logLocation="$archiveStorePath/log"


if [ -z "$1" ]; then
    finalArchiveName="site_$(date +%Y-%m-%d)_fullSiteBackup.tar.gz";
else
    finalArchiveName="site_$1_fullSiteBackup.tar.gz";
fi

timestamp=`date --rfc-3339=seconds`

echo "##############################" >> "$logLocation";
echo "[$timestamp]" >> "$logLocation";
echo "Saving as: $finalArchiveName" >> "$logLocation";

rm -rf "$archiveStorePath"/"$finalArchiveName"

/bin/tar -zcvf \
        "$archiveStorePath"/"$finalArchiveName" \
        "$webRoot"  >/dev/null 2>&1


if [ $? -eq 0 ]; then
    echo "[PASS] site backup" >> "$logLocation";
else
    echo "[FAIL] site backup" >> "$logLocation";
fi

echo "" >> $logLocation;
