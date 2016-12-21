#!/usr/php/54/usr/bin/php
<?php

$baseWebPath = "/path/to/public_html"

$baseBackupPath = "/backup/location";


// $dbsToBackup[] = array("Site Name", "slugForBackupFile", "path/to/wp-config");

outputHeader();

foreach ($dbsToBackup as $dbToBackup) {

	$creds['dbname'] = parseWpConfig("DB_NAME", $dbToBackup[2]);
	$creds['user'] = parseWpConfig("DB_USER", $dbToBackup[2]);
	$creds['pw'] = parseWpConfig("DB_PASSWORD", $dbToBackup[2]);

	$outputFile = $baseBackupPath . "/" . $dbToBackup[1] . "_dbBackup_" . 
			date("m-d-y") . ".sql";

	runBackup($creds, $outputFile);
	echo "	" . $dbToBackup[0] . "\n";
}
echo "\n\n";

/******************
* FUNCTIONS
******************/


function outputHeader() {
	echo "################\n";
	echo "[" . date(DATE_RFC2822) . "]\n";

}

function runBackup($creds, $outputLocation, $async = false) {
	$cmd = 	"mysqldump " .	
		"-u " . $creds['user'] . " " . 	
		"-p" . $creds['pw'] . " " . 
		$creds['dbname'];
	if ($async) {	
		return shell_exec($cmd . " > " . $outputLocation . " &");
	} else {
		return shell_exec($cmd . " > " . $outputLocation);
	}
}



function parseWpConfig($select, $fileToSearch) {

	$cmd = 	"cat " . $fileToSearch . 
		" | grep " . $select . 
		" | cut -d \' -f 4";
	
	$output = shell_exec($cmd);
	$output = trim($output);

	return $output;
}
