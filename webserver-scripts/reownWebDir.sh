#!/bin/bash

# Add user to www-data
# usermod -a -G www-data benyanke

# Ensure all files owned by www-data
sudo chown -R www-data:www-data /var/www

# modify all file permissions to proper
sudo find /var/www -type d -exec chmod 0775 {} \;
sudo find /var/www -type f -exec chmod 0664 {} \;

sudo chmod +x /var/www/*.sh
