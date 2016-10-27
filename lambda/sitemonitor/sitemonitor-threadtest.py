#!/usr/bin/python

# installed modules:
import json

# PY2 Specific Packages
import urllib2
import pyping
import sys
import socket
import ssl


import threading


def ssl_expiry_datetime(hostname):
    ssl_date_fmt = r'%b %d %H:%M:%S %Y %Z'

    context = ssl.create_default_context()
    conn = context.wrap_socket(
        socket.socket(socket.AF_INET),
        server_hostname=hostnam
    )
    # 3 second timeout because Lambda has runtime limitations
    conn.settimeout(3.0)

    conn.connect((hostname, 443))
    ssl_info = conn.getpeercert()
    # parse the string from the certificate into a Python datetime object
    return datetime.datetime.strptime(ssl_info['notAfter'], ssl_date_fmt)


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

        actualCode = int(code)
        expectedCode = int(data['expected_http_code'])

        if 'expected_http_code' in data:
            if expectedCode != actualCode:
                #print "(TLS) HTTP %s : unexpected response for %s" % (actualCode,url)
                print "HTTP CODE Expected: %s | Returned: %s || BAD || %s" % (expectedCode,actualCode, url)
        #    else:
                #print "HTTP CODE Expected: %s | Returned: %s || GOOD || %s" % (expectedCode,actualCode, url)

            if 'response_body_minimum_size' in data:
                if data['response_body_minimum_size'] < size:
                    print "Page is shorter than expected by %n bytes" % (data['response_body_minimum_size'] - size)


    return 0

def httpsscan( data ):

    if 'url' in data:

        url = "https://" + str(data["url"])

        response = urllib2.urlopen(url)
        html = response.read()
        code = response.getcode()
        size = sys.getsizeof(html)

        actualCode = int(code)
        expectedCode = int(data['expected_http_code'])

        if 'expected_http_code' in data:
            if expectedCode != actualCode:
                #print "(TLS) HTTP %s : unexpected response for %s" % (actualCode,url)
                print "HTTP TLS CODE Expected: %s | Returned: %s || BAD || %s" % (expectedCode,actualCode, url)
            #else:
                #print "HTTP TLS CODE Expected: %s | Returned: %s || GOOD || %s" % (expectedCode,actualCode, url)

            if 'response_body_minimum_size' in data:
                if data['response_body_minimum_size'] < size:
                    print "Page is shorter than expected by %n bytes" % (data['response_body_minimum_size'] - size)

    return 0


def pingscan( data ):

    if 'url' in data:
        url = data["url"]

        r = pyping.ping(url)

        actualPingTime = r.avg_rtt


        if r.ret_code != 0:
            print "PING FAIL for " , data['url']
        elif 'expected_maximum_response_time' in data:
            expectedMaxPingTime = float(data['expected_maximum_response_time'])
            if expectedMaxPingTime > actualPingTime:
                print "HIGH PING. Expected max: %s | Actual: %s" % (expectedMaxPingTime, actualPingTime)
            #else:
            #    print "Normal ping. Expected max: %s | Actual: %s" % (expectedMaxPingTime, actualPingTime)

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

threads = []

for account in data:
#    print "\n##########"
#    print "Scanning: %s " % account["sitename"]

    services = account["services"]

    for service in services:
#        print("Type: ", service["type"])

        if service["type"] == "http" :

			t = threading.Thread(target=httpscan, args=(service,))
			threads.append(t)
			t.start()

        elif service["type"] == "https" :

			t = threading.Thread(target=httpsscan, args=(service,))
			threads.append(t)
			t.start()

        elif service["type"] == "ping" :

			t = threading.Thread(target=pingscan, args=(service,))
			threads.append(t)
			t.start()

        else:

            print "Scan type unrecognized"


#        print(service)
