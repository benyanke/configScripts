#!/bin/bash

/bin/grep -sozZe '^DBUS_SESSION_BUS_ADDRESS=[a-zA-Z0-9:=,/-]*$' /proc/*/environ \
| /usr/bin/php -r '
        $busses = array();
        array_shift($argv);
        while($ln = fgets(STDIN)) {
                list($f, $env) = explode("\0", $ln, 2);
                if (file_exists($f)) {
                        $user = fileowner($f);
                        $busses[$user][trim($env)] = true;
                }
        }
        foreach ($busses as $user => $user_busses) {
                foreach ($user_busses as $env => $true) {
                        if (pcntl_fork()) {
                                posix_seteuid($user);
                                $env_array = array("DBUS_SESSION_BUS_ADDRESS" => preg_replace("/^DBUS_SESSION_BUS_ADDRESS=/", "", $env));
                                pcntl_exec("/usr/bin/notify-send", $argv, $env_array);
                        }
                }
        }
' -- "$@"
