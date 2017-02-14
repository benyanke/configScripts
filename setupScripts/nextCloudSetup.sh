
#!/bin/bash

# Not complete yet
# based on https://www.linux.com/learn/how-install-nextcloud-server-ubuntu%20%20

# add run as root check


# Update apt repo
apt update

# Install packages
apt install -y lamp-server^
apt install -y libxml2-dev php-zip php-dom php-xmlwriter php-xmlreader php-gd php-curl php-mbstring

# Enables rewrite
a2enmod rewrite
sudo service apache2 reload

# Install db
apt install -y mariadb-server

# Download NextCloud install
installFile="nextcloud-9.0.53.tar.bz2"

wget https://download.nextcloud.com/server/releases/$installFile
tar -vxjf $installFile

rm $installFile

mv nextcloud /var/www


# START NEXTCLOUD PROVIDED SCRIPT

ocpath='/var/www/nextcloud'

htuser='www-data'

htgroup='www-data'

rootuser='root'


printf "Creating possible missing Directories\n"

mkdir -p $ocpath/data

mkdir -p $ocpath/assets

mkdir -p $ocpath/updater


printf "chmod Files and Directories\n"

find ${ocpath}/ -type f -print0 | xargs -0 chmod 0640

find ${ocpath}/ -type d -print0 | xargs -0 chmod 0750


printf "chown Directories\n"

chown -R ${rootuser}:${htgroup} ${ocpath}/

chown -R ${htuser}:${htgroup} ${ocpath}/apps/

chown -R ${htuser}:${htgroup} ${ocpath}/assets/

chown -R ${htuser}:${htgroup} ${ocpath}/config/

chown -R ${htuser}:${htgroup} ${ocpath}/data/

chown -R ${htuser}:${htgroup} ${ocpath}/themes/

chown -R ${htuser}:${htgroup} ${ocpath}/updater/


chmod +x ${ocpath}/occ


printf "chmod/chown .htaccess\n"

if [ -f ${ocpath}/.htaccess ]

then

 chmod 0644 ${ocpath}/.htaccess

 chown ${rootuser}:${htgroup} ${ocpath}/.htaccess

fi

if [ -f ${ocpath}/data/.htaccess ]

then

 chmod 0644 ${ocpath}/data/.htaccess

 chown ${rootuser}:${htgroup} ${ocpath}/data/.htaccess

fi

# END NEXTCLOUD PROVIDED SCRIPT


apacheConf="/etc/apache2/sites-available/nextcloud.conf"
touch $apacheConf;

Alias /nextcloud "/var/www/nextcloud/"

echo "<Directory /var/www/nextcloud/>
 Options +FollowSymlinks
 AllowOverride All

<IfModule mod_dav.c>
 Dav off
</IfModule>

SetEnv HOME /var/www/nextcloud
SetEnv HTTP_HOME /var/www/nextcloud

</Directory>" > $apacheConf

ln -s $apacheConf /etc/apache2/sites-enabled/nextcloud.conf


# Setup apache mods
a2enmod headers
a2enmod env
a2enmod dir
a2enmod mime

# Enable SSL
a2enmod ssl
a2ensite default-ssl

# Reload Apache
service apache2 reload



# Setup DB

# sudo mysql -u root -p (Youâ€™ll be prompted for your MySQL root user password)
# CREATE DATABASE nextcloud;
# CREATE USER nextclouduser@localhost IDENTIFIED BY â€˜PASSWORDâ€™; (Where PASSWORD is a password you want to use for the nextcloud database users)
# GRANT ALL PRIVILEGES ON nextcloud.* TO nextclouduser@localhost;
# EXIT

