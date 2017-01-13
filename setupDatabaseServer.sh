#!/bin/bash

# Upgrade to root
if [ "$(whoami)" != "root" ]
then
    sudo su -s "$0"
    exit
fi


a2enmod ssl
a2enmod rewrite

apt update
apt install -y mariadb-server phpmyadmin php-mbstring php-gettext  python-letsencrypt-apache

email="PUT EMAIL HERE"
domain="$1"

verifyWebRoot="/var/www/le-verify-dir"
phpmyadminDir="/usr/share/phpmyadmin/"

blankfile="/var/www/blankfile.php"

apacheTempConfigPath="/etc/apache2/sites-enabled"
apacheConfigPath="/etc/apache2/sites-available"

webservConfigFile="$apacheTempConfigPath/temp.conf"
webservTlsConfigFile="$apacheConfigPath/$domain.conf"

mkdir -p $verifyWebRoot

touch $blankfile
touch $verifyWebRoot/index.php

# Setup temporary config file for first verification

configContent=`cat <<EOF

<VirtualHost *:80>
    ServerName $domain
    ServerAlias www.$domain
    DocumentRoot $verifyWebRoot/
</VirtualHost>

EOF
`

echo "$configContent" > $webservConfigFile

service apache2 reload

letsencrypt certonly --webroot -w $verifyWebRoot -d $domain -d www.$domain --email $email --text --agree-tos

rm $webservConfigFile

configContent=`cat <<EOF

<IfModule mod_ssl.c>

    # $domain
    <VirtualHost *:443>
        ServerName $domain
        ServerAlias www.$domain
        ServerAdmin $email

        DocumentRoot $phpmyadminDir

	Alias "/.well-known/acme-challenge" "$verifyWebRoot/.well-known/acme-challenge"

        <Directory $phpmyadminDir >
#            Options Indexes FollowSymLinks
            AllowOverride All
            Require all granted
        </Directory>


	RewriteEngine On

	# IP Addresses To Allow
	RewriteCond %{REMOTE_ADDR} !1\.2\.3\.4
	RewriteCond %{REMOTE_ADDR} !1\.2\.3\.4
	RewriteCond %{REMOTE_ADDR} !1\.2\.3\.4

	# Let's Encrypt Override
	RewriteCond %{REQUEST_URI} !^.*/.well-known/.*$ [NC]
	RewriteRule ^(.*)$ $blankfile

	ErrorLog \\${APACHE_LOG_DIR}/error.log
	CustomLog \\${APACHE_LOG_DIR}/access.log combined

	SSLEngine on

	SSLCertificateFile  /etc/letsencrypt/live/$domain/cert.pem
	SSLCertificateKeyFile /etc/letsencrypt/live/$domain/privkey.pem
	SSLCertificateChainFile /etc/letsencrypt/live/$domain/chain.pem

	<FilesMatch "\.(cgi|shtml|phtml|php)$">
		SSLOptions +StdEnvVars
	</FilesMatch>
	<Directory /usr/lib/cgi-bin>
		SSLOptions +StdEnvVars
	</Directory>

	BrowserMatch "MSIE [2-6]" nokeepalive ssl-unclean-shutdown downgrade-1.0 force-response-1.0
	# MSIE 7 and newer should be able to use keepalive
	BrowserMatch "MSIE [17-9]" ssl-unclean-shutdown

	</VirtualHost>

</IfModule>


<VirtualHost *:80>
	ServerName $domain
	ServerAlias www.$domain
	ServerAdmin $email

	Alias "/.well-known/acme-challenge" "$verifyWebRoot/.well-known/acme-challenge"

	DocumentRoot "$verifyWebRoot"

	RewriteEngine On
	RewriteRule ^ https://$domain%{REQUEST_URI} [END,QSA,R=permanent]

</VirtualHost>




# vim: syntax=apache ts=4 sw=4 sts=4 sr noet

EOF
`

rm $webservTlsConfigFile $apacheTempConfigPath/$domain.conf

echo "$configContent" > $webservTlsConfigFile


ln -s $webservTlsConfigFile $apacheTempConfigPath/$domain.conf

service apache2 reload
service apache2 start






