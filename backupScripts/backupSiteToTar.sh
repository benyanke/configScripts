#!/bin/bash

# DB Connection Info
db=""
u=""
pw=""

# DB Search and Replace
old=""
new=""

dbFile="/var/www/html/db.sql"

mysqldump -u $u -p$pw $db | sed "s/$old/$new/g" > $dbFile
tar cvzf rnd-dev.tar.gz html/
rm $dbFile







