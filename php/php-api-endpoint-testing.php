<?php

/*
* This is handy for post request debugging - it returns the received post data as json
* along with a cache-buster parameter
*/

$data['discard'] = mt_rand(10000000,99999999);
$data['received_post_data'] = $_POST;

$json = json_encode($data);


// Useful for intentionally delayed responses
// sleep(3);
// sleep(mt_rand(1,9));

echo $json;

// Can also store to a file to watch returns on the server site with something like:
// $ watch -n 0.5 "cat data"
//
// file_put_contents("data", json_encode($_POST));


