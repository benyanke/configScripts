  <?php

  // change 'false' to 'true' to enable debugging
   define("DEBUG", false);
//  define("DEBUG", true);

  // Setup basic info
  $currentDir = getcwd();
  $DS = DIRECTORY_SEPARATOR;
  $jsonInfoFile = $currentDir . $DS . "info.json";
  register_shutdown_function('shutdown');

  // Get URL data
  $tokensToCheck = array("statictoken");
  $optionalTokensToCheck = array("ip", "secret");

  // Process required input fields
  foreach($tokensToCheck as $t) {
  	if ( isset($_GET[$t]) ){
  		$input[$t] = $_GET[$t];
  		if(DEBUG) echo "'$t' statement found<br />";
  	} else {
  		if(DEBUG) { echo "'$t' statement not found - error<br />"; die; } else { callError(); die; }
  	}
  }

  // Process optional input fields
  foreach($optionalTokensToCheck as $t) {
  	if ( isset($_GET[$t]) ){
  		$input[$t] = $_GET[$t];
  		if(DEBUG) echo " '$t' statement found - optional<br />";
  	} else {
      $input[$t] = null;
  		if(DEBUG) echo " '$t' statement not found - optional<br />";
  	}
  }

  // Get config info from config file specified above
  $data = json_decode(file_get_contents($jsonInfoFile));

  // Debugging statement
  if(DEBUG && false) {
  	echo "<pre>";
  	print_r($data->clients);
  }

  // Storing this for later use
  $date = new DateTime();
  $unixtime = $date->format('U');

  // Loop through each client to find matching one
  $foundRow = null;

  foreach($data->clients as $c) {
  	if($input['statictoken'] == $c->statictoken) {
  		if(DEBUG) echo "Found entry {$c->description} with token {$c->statictoken}<br />";
  		$foundRow = $c;
  		break;
  	}
  }

  // Check to see if loop found entry or not
  if($foundRow == null) {
  	if(DEBUG) echo "Found no valid entry with token {$input['statictoken']}<br />";
    callError();
    die;
  }

  // If IP is not specified in the request
  if(is_null($input['ip'])) {
    $input['ip'] = $_SERVER['REMOTE_ADDR'];
  }

  if(DEBUG) echo "<hr>";

  // Loop through all associated domains in config file
  foreach($c->domains as $d) {
    $domain = $d->subdomain . "." . $d->topdomain;

    // If record is a wildcard, here we randomize the domain to
    // ensure the ip test is performed accurately
    $domainToTest = str_replace("*", mt_rand(), $domain);

    // Get IP by domain name
    $domainDnsRecord = gethostbyname($domainToTest);
//    $domainDnsRecord = exec('dig +short . ' . $domainToTest);

    // Output debugging statement
    if(DEBUG) {
      echo "Testing: ";
      echo $domain;
      echo "<br />";
      echo "IP input: ";
      echo $input['ip'];
      echo "<br />";
      echo "DNS record: ";
      echo $domainDnsRecord;
      echo "<br />";
    }

    // If IP already matches record, no change needed
    if($domainDnsRecord == $input['ip']) {
      echo "Record already up-to-date.<br />";
    }

    if(DEBUG)
      echo "Record changing from " . gethostbyname($domainToTest) . " to {$input['ip']}<br />";


  	$key = $data->apikeys->{$d->apikey};

  	// Get record ID so we can find which one to change
  	$recordId = findRecordIdByName($d->topdomain, $d->subdomain, $key);

    if(is_null($recordId)) {
      // Record not found
      echo "Record for \"{$d->subdomain}.{$d->topdomain}\" could not be found.";
    } else {
      // Once we have the record ID, change it's value
      changeDomainRecord($d->topdomain, $d->subdomain, $recordId, $input['ip'], $key);
    }

    if(DEBUG) echo "<hr>";
  }


  /*************** Functions ***************/

  function callError() {
    global $error;

    $error = true;
  }

  function shutdown() {
  	global $error;

  	if(isset($error) && $error) {
  		echo "Invalid request.";
  	} else {
      if(DEBUG) echo "Success.";
  	}

  }


  function changeDomainRecord($topDomain, $subDomain, $recordId, $ip, $key) {
    $request = "https://api.digitalocean.com/v2/domains/" . $topDomain . "/records/" . $recordId;

    $data = '{"data":"' . $ip . '"}';

    $results = json_decode(curlRequest($request, $key, $data));


    if(is_object($results) && isset($results->domain_record) && $results->domain_record instanceof stdClass) {

      // If change was successful
      return true;

    } else {

      // If change was not successful
      // if(DEBUG) print_r($results);
      if(DEBUG) echo "DNS record change could not be completed.<br />";
      return false;

    }



  }

  function findRecordIdByName($topDomain, $subDomain, $key) {

      $subDomain = trim($subDomain);
      $topDomain = trim($topDomain);

      // Find the API's ID for the record in question
  		$request = "https://api.digitalocean.com/v2/domains/" . $topDomain . "/records";
      $found = false;
      $loopTimes = 1;

      while ($found == false) {

        $results = json_decode(curlRequest($request, $key));
        $aRecordId = null;

  //      print_r($results);

  //      echo "<pre>";

        foreach($results->domain_records as $r) {
  //        print_r($r);
  //        echo "$r->name </br>";
          if($subDomain == $r->name) {
              $aRecordId = $r->id;
              $found = true;
              break;
          }
        }
  //      print_r($results->links->pages->next)

        // Go to next page if not found, and next page exists
        if(isset($results->links->pages->next) && !$found) {
          $request = $results->links->pages->next;
          // echo "next request: " . $request;
        } else {
          // Not really found, but need to exit the loop here.
          $found = true;
          break;
        }
      }

      if(is_null($aRecordId)) {
        if(DEBUG) echo "'A record' for {$subDomain}.{$topDomain} could not be found. Creating it.<br />";

        // Create new record here

        // if it works, fix this.
        return null;
      }

      if(DEBUG) {
        echo "'A record' for {$subDomain}.{$topDomain} found. Record id: $aRecordId.<br />";
      }


      return $aRecordId;

  }


  function curlRequest($url, $key, $putData = null) {

  	$crl = curl_init();

  	$headr = array();
  	//$headr[] = 'Content-length: 0';
  	$headr[] = 'Content-Type: application/json';
  	$headr[] = 'Authorization: Bearer ' . $key;

  	curl_setopt($crl, CURLOPT_HTTPHEADER,$headr);
    curl_setopt($crl, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($crl, CURLOPT_FOLLOWLOCATION, true);

    if(!is_null($putData)) {
      curl_setopt($crl, CURLOPT_CUSTOMREQUEST, "PUT");
      curl_setopt($crl, CURLOPT_POSTFIELDS,$putData);
    }

  //	curl_setopt($crl, CURLOPT_POST,true);

  	curl_setopt($crl, CURLOPT_URL, $url);

  	$rest = curl_exec($crl);

  	curl_close($crl);

  	return $rest;
  }

