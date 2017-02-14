<?php

/* This page is only called when the htaccess rules direct clients here */

if ($_SERVER['REMOTE_ADDR'] == "10.10.10.10") {
        header("Location: http://example.com/");
} else {
        header('HTTP/1.1 503 Service Temporarily Unavailable');
        header('Status: 503 Service Temporarily Unavailable');
        header('Retry-After: 300');
}

?>
<html>
        <head>
        <title>Down for Maintenance</title>
        </head>
<body style="background-color: #264785;
    background-image: url('http://example.com/background);
    background-repeat: repeat;
    background-position: top center;
    background-attachment: scroll;">
        <br /><br /><br /><br /><br />
        <center>
                <img src="http://example.com/sitelogo.jpg">
                <br />
                <br />
                <br />
                <br />

                <h1 style="color:white">We're down for some temporary maintenance</h1>
                <h2 style="color:white">We'll be back soon!</h2>
        </center>

</body>


