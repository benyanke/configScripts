#!/usr/bin/python

# installed modules:
import json


# PY2 Specific Packages
import urllib2
import pyping
import sys
import threading
import socket
import ssl

# Functions

output = "OUTPUT\n"

def addToOutput( input ) :

	output += "[] %s\n" % input


def ssl_valid_time_remaining(hostname):
    """Get the number of days left in a cert's lifetime."""
    expires = ssl_expiry_datetime(hostname)
    logger.debug(
        "SSL cert for %s expires at %s",
        hostname, expires.isoformat()
    )
    return expires - datetime.datetime.utcnow()

def ssl_expires_in(hostname, buffer_days=14):
    """Check if `hostname` SSL cert expires is within `buffer_days`.

    Raises `AlreadyExpired` if the cert is past due
    """
    remaining = ssl_valid_time_remaining(hostname)

    # if the cert expires in less than two weeks, we should reissue it
    if remaining < datetime.timedelta(days=0):
        # cert has already expired - uhoh!
        raise AlreadyExpired("Cert expired %s days ago" % remaining.days)
    elif remaining < datetime.timedelta(days=buffer_days):
        # expires sooner than the buffer
        return True
    else:
        # everything is fine
        return False


def httpscan( data ):

	if 'url' in data:

		url = "http://" + str(data["url"])

		response = urllib2.urlopen(url)
		html = response.read()
		code = response.getcode()
		size = sys.getsizeof(html)

		print code

		if 'expected_http_code' in data:
			if data['expected_http_code'] != code:
				addToOutput("HTTP " + code + " : unexpected response for " + url );
			if 'response_body_minimum_size' in data:
				if data['response_body_minimum_size'] < size:
					addToOutput("Page is shorter than expected by " + (data['response_body_minimum_size'] - size) + " bytes.");


	return 0

def httpsscan( data ):

	return 0


def pingscan( data ):

	if 'url' in data:
		url = data["url"]

		print "Pinging %s" % url

		r = pyping.ping(url)

		time = r.avg_rtt

		if r.ret_code != 0:
			print "PING FAIL for %s" % url
		elif 'expected_maximum_response_time' in data:
			if data['expected_maximum_response_time'] > time:
				print "PING FAIL for %s" % url

	return 0


## MAIN

configFile="https://raw.githubusercontent.com/benyanke/configScripts/master/lambda/sitemonitor/site-monitor-settings.json"

# Get config info from github file

# PY2
config = urllib2.urlopen(configFile).read()

# PY3
#config = urllib.request.urlopen(configFile).read()


# Convert content to string
config = config.decode("utf-8")

# Load json into file
data = json.loads(config)

# Initial pre-loop processing
data = data["accounts"]

#print(data)

# Setup array for multithreading
threads = []

for account in data:
	print "\n##########"
	print "Scanning: %s " % account["sitename"]

	services = account["services"]

	for service in services:
#		print("Type: ", service["type"])

		if service["type"] == "http" :

#			httpscan(service)

			t = threading.Thread(target=httpscan, args=(service,))
			threads.append(t)
			t.start()


		elif service["type"] == "https" :

#			httpsscan(service)

			t = threading.Thread(target=httpsscan, args=(service,))
			threads.append(t)
			t.start()


		elif service["type"] == "ping" :


#			pingscan(service)

			t = threading.Thread(target=pingscan, args=(service,))
			threads.append(t)
			t.start()


		else:

			print "Scan type unrecognized"


print output
#		print(service)
