#!/usr/bin/python

# installed modules:

#import json

# PY2 Specific Packages
#import urllib2
#import pyping
#import sys

# PY3 Specific packages
# import urllib.request

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
				print "HTTP %s : unexpected response for %s" % (code,url)
			if 'response_body_minimum_size' in data:
				if data['response_body_minimum_size'] < size:
					print "Page is shorter than expected by %n bytes" % (data['response_body_minimum_size'] - size)


	return 0

def httpsscan( data ):

	return 0


def pingscan( data ):

	if 'url' in data:
		url = data["url"]

		r = pyping.ping(url)

		time = r.avg_rtt

		if r.ret_code != 0:
			print "PING FAIL"
		elif 'expected_maximum_response_time' in data:
			if data['expected_maximum_response_time'] > time:
				print "HIGH PING"

	return 0
