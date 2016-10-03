#!/usr/bin/python

# installed modules:

import json

# PY2 Specific Packages
import urllib2
import pyping
import sys

# PY3 Specific packages
# import urllib.request

# Import functions from other file
import sitemoninc

## MAIN

configFile="https://raw.githubusercontent.com/benyanke/configScripts/master/lambda/site-monitor-settings.json"

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

for account in data:
	print "\n##########"
	print "Scanning: %s " % account["sitename"]

	services = account["services"]

	for service in services:
#		print("Type: ", service["type"])

		if service["type"] == "http" :

			httpscan(service)

		elif service["type"] == "https" :

			httpsscan(service)

		elif service["type"] == "ping" :

			pingscan(service)

		else:

			print "Scan type unrecognized"


#		print(service)
