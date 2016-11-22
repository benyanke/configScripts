
#!/bin/bash

# Upgrade to root
if [ "$(whoami)" != "root" ]
then
    sudo su -s "$0"
    exit
fi


domain=$1
webRoot="/var/www/$domain/public_html/"
apacheTempConfigPath="/etc/apache2/sites-enabled"
apacheConfigPath="/etc/apache2/sites-available"
webservConfigFile="$apacheTempConfigPath/temp.conf"
webservTlsConfigFile="$apacheConfigPath/$domain.conf"

mkdir -p $webRoot

configContent=`cat <<EOF

<VirtualHost *:80>
    ServerName $domain
    ServerAlias www.$domain
    DocumentRoot /var/www/$domain/public_html/
</VirtualHost>

EOF
`

echo "$configContent" > $webservConfigFile

service apache2 reload

letsencrypt certonly --webroot -w $webRoot -d $domain -d www.$domain

rm $webservConfigFile

configContent=`cat <<EOF

<IfModule mod_ssl.c>

    # $domain
    <VirtualHost *:443>
		ServerName $domain
		ServerAlias www.$domain
		ServerAdmin benyanke@gmail.com
		
		DocumentRoot /var/www/$domain/public_html/
		
		<Directory /var/www/$domain/public_html/ >
			Options Indexes FollowSymLinks
			AllowOverride All
			Require all granted
		</Directory>
		
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

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet

EOF
`

rm $webservTlsConfigFile $apacheTempConfigPath/$domain.conf

echo "$configContent" > $webservTlsConfigFile


ln -s $webservTlsConfigFile $apacheTempConfigPath/$domain.conf

service apache2 reload
service apache2 start
