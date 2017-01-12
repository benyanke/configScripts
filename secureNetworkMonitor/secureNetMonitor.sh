#!/bin/bash

# Steps:

# This script runs upon any network connect
# Get WAN IP

# If CURL failed:
  # send warning that WAN is not up, may need manual override
  # check again later, or loop to top again

# If CURL succeeded:
  # check if WAN IP is a secure IP or IP block
  # If YES, alert that connected to secure WAN
  # if NO, block all connections until user interface decides to connect to VPN or not
    # OR: just connect automatically

