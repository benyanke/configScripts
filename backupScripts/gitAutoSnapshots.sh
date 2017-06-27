#!/bin/bash

# Still a work in progress

echo ""

function snapshotBody() {
        dir=$1

        git --git-dir $dir/.git add . && git --git-dir $dir/.git commit -m "Snapshot on `date +%Y-%m-%d`"
}

function snapshot() {
        dir=$1

        printf "Running snapshot for: "
        printf $dir
        printf "\n\n"

#	snapshotBody $dir &>/dev/null &
        snapshotBody $dir
}

www="/home5/caladven/public_html"


snapshot "$www/wp-content/plugins"
snapshot "$www/wp-content/themes"

sleep 3
echo ""
printf "####################################\n"
echo "Snapshot successfully pushed to background - you may now exit"
printf "####################################\n"
echo ""






