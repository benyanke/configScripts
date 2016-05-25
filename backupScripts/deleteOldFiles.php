
#!/usr/bin/php

<?php

// Delete files older than x days
$days = 7;

$basePath = "/var/www/backups/filesystemBackups";

// nb: don't clear database backups. They're small and they self manage
$folderToProcess[] = "themeBackups";
$folderToProcess[] = "fullSiteBackups";

$filesToKeep[] = "log";
$filesToKeep[] = "logs";
$filesToKeep[] = ".htaccess";

if (in_array("-y", $argv)) {

    // continuing

} else {

    $output = readline("Are you sure you want to delete all backups older than $days days? [Y/N] ");
    echo "\n";

    if (strtolower($output) == "y") {
        echo "Deleting all old files.\n\n";
    } else {
        echo "Aborting deletion.\n\n";
        die;
    }

}


$count = 0;

foreach($folderToProcess as $folder) {

    $folder = $basePath . $folder;

    if (file_exists($folder)) {
        foreach (new DirectoryIterator($folder) as $fileInfo) {
            if ( $fileInfo->isDot() || $fileInfo->isDir() ) {
                continue;
            }

            if ((time() - $fileInfo->getCTime()) > ($days*24*60*60)) {
                $currentFilename = $fileInfo->getFilename();

                if(skipFile($currentFilename)) {
            //      echo "skipping file $currentFilename" . "\n";
                } else {
                    echo "deleting: " . $fileInfo->getRealPath() . "\n";
                    unlink($fileInfo->getRealPath());
                    $count++;
                }
            }
        }
    }

} // end foreach

echo "Run complete. $count files deleted.\n";

function skipFile($filename) {

    global $filesToKeep;

    foreach ($filesToKeep as $file)  {
        if (strtolower($file) == strtolower($filename)) {
            return true;
        }
    }

    return false;

}

?>
