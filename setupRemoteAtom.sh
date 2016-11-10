#!/bin/bash

# Sudo check

curl -o /usr/local/bin/rmate https://raw.githubusercontent.com/aurora/rmate/master/rmate

chmod +x /usr/local/bin/rmate
ln -s /usr/local/bin/rmate /usr/local/bin/atom

