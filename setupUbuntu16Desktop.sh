#!/bin/bash

# get current user, and home directory path
currentUser=$SUDO_USER
tempDir="/home/$currentUser/temp"
homeDir="/home/$currentUser"

mkdir $tempDir -p

function reownHome() {
	chown benyanke:benyanke $homeDir -R
}


if [ "$EUID" -ne 0 ];  then
 echo "Please run as root";
 exit
fi

#############
# NONROOT TASKS
#############


# Change Desktop

rm $tempDir/desktop.jpg -r
wget https://researchvoodoo.files.wordpress.com/2013/06/n01582_10.jpg -O $tempDir/desktop.jpg

reownHome

gsettings set org.gnome.desktop.background picture-uri "file://$tempDir/desktop.jpg"


#############
# ROOT TASKS
#############

# Install packages
add-apt-repository universe
apt-get update
apt-get upgrade -y
apt-get dist-upgrade -y

# CLI packages
apt-get install -y htop git tree openvpn jq
echo "### Installed CLI tools ###" > $homeDir/installedTools
echo " - htop (process manager)" >> $homeDir/installedTools
echo " - git (version control)" >> $homeDir/installedTools
echo " - openvpn (vpn)" >> $homeDir/installedTools
echo " - tree (directory structure viewer)" >> $homeDir/installedTools
echo " - jq (json formatter)" >> $homeDir/installedTools
echo "" >> $homeDir/installedTools

# Install gui packages
apt-get install -y inkscape gimp lyx audacity filezilla cheese vlc musescore minitube eclipse
echo "### Installed GUI tools ###" >> $homeDir/installedTools
echo " - Inkscape (Vector Graphics)" >> $homeDir/installedTools
echo " - GIMP (Raster Graphics)" >> $homeDir/installedTools
echo " - LyX (LaTeX tool)" >> $homeDir/installedTools
echo " - Audacity (Audio editor)" >> $homeDir/installedTools
echo " - FileZilla (FTP and SFTP client)" >> $homeDir/installedTools
echo " - Cheese (Camera viewer)" >> $homeDir/installedTools
echo " - VLC (Media viewer)" >> $homeDir/installedTools
echo " - MuseScore (Music Engraving)" >> $homeDir/installedTools
echo " - MiniTube (Youtube Player)" >> $homeDir/installedTools
echo " - Eclipse (Development)" >> $homeDir/installedTools

# Install Chrome
apt-get install -y libgconf2-4 libnss3-1d libxss1
if [ $? != 0 ]; then
  apt-get install -f -y;
  apt-get install -y libgconf2-4 libnss3-1d libxss1
fi

rm  $tempDir/chrome.deb -f
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O $tempDir/chrome.deb

dpkg --install $tempDir/chrome.deb

if [ $? != 0 ]; then
  apt-get install -f -y;
  dpkg --install $tempDir/chrome.deb;
fi

echo " - Chrome (Browser)" >> $homeDir/installedTools


# Install Dropbox
#apt-get install -y libgconf2-4 libnss3-1d libxss1
#if [ $? != 0 ]; then
#  apt-get install -f -y;
#  apt-get install -y libgconf2-4 libnss3-1d libxss1
#fi

rm  $tempDir/dropbox.deb -f
wget https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2015.10.28_amd64.deb -O $tempDir/dropbox.deb

dpkg --install $tempDir/dropbox.deb

if [ $? != 0 ]; then
  apt-get install -f -y;
  dpkg --install $tempDir/dropbox.deb;
fi

# restart nautilus
nautilus -q && nautilus &

echo " - Dropbox (File Sync)" >> $homeDir/installedTools


# Install OwnCloud
sh -c "echo 'deb http://download.opensuse.org/repositories/isv:/ownCloud:/desktop/Ubuntu_16.04/ /' >> /etc/apt/sources.list.d/owncloud-client.list"
apt-get update
apt-get install owncloud-client -y --allow-unauthenticated

echo " - OwnCloud (File Sync)" >> $homeDir/installedTools

# add update features
wget http://download.opensuse.org/repositories/isv:ownCloud:desktop/Ubuntu_16.04/Release.key -O $tempDir/oc.key
sudo apt-key add - < $tempDir/oc.key
rm $tempdir/oc.key -f


reownHome


# Setup nightly package upgrade 

#write out current crontab
crontab -l > $tempDir/mycron
#echo new cron into cron file
echo "# Upgrade packages nightly" >> $tempDir/mycron
echo "0 4 * * * apt-get update && apt-get dist-upgrade -y >/dev/null 2>&1" >> $tempDir/mycron
echo "" >> $tempDir/mycron
#install new cron file
crontab $tempDir/mycron
rm $tempDir/mycron



# Upgrade all packages before finishing
apt-get update
apt-get upgrade -y
apt-get dist-upgrade -y

# Add new programs to launcher
exit;

myfile='firefox.desktop'
list=`gsettings get com.canonical.Unity.Launcher favorites`
newlist=`echo $list | sed s/]/", '${myfile}']"/`
gsettings set com.canonical.Unity.Launcher favorites "$newlist"
su $currentUser -c "unity --replace"

reownHome

