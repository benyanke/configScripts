#!/bin/bash


if [ "$EUID" -ne 0 ]
  then
  echo "Starting...."
  else
   echo "Please do not run as root"
fi

#CHANGE THESE

# destination for papertrail logging
#example:
papertrailDest="logs12345.papertrailapp.com:12345"


# get current user, and home directory path
currentUser=$SUDO_USER
tempDir="/home/$currentUser/temp"
homeDir="/home/$currentUser"

# This file contains a list of installed tools for user reference
listfile="$homeDir/installedtools.md"

mkdir $tempDir -p


function reownHome() {
	chown $currentUser:$currentUser $homeDir -R
}


#############
# NONROOT TASKS
#############

# Change Desktop

mkdir -p $homeDir/Pictures/DesktopBackgrounds

function getBackgroundFile() {
  filename=$1;
  desktopBgBaseUrl="https://github.com/benyanke/configScripts/raw/master/img/desktopbackgrounds";

  rm "$homeDir/Pictures/DesktopBackgrounds/$filename" -r
  wget "$desktopBgBaseUrl/$filename" -O "$homeDir/Pictures/DesktopBackgrounds/$filename"

}

getBackgroundFile "cat6.jpg"
getBackgroundFile "cloud.png"
getBackgroundFile "inception-code.jpg"
getBackgroundFile "knight.jpg"
getBackgroundFile "ubuntu-blue.jpg"
getBackgroundFile "ubuntu-grey.jpg"


reownHome

##### For Unity only

# Change desktop background
gsettings set org.gnome.desktop.background picture-uri "file://$homeDir/Pictures/DesktopBackgrounds/knight.jpg"

# Change menus to in the window
gsettings set com.canonical.Unity integrated-menus true

# Change scrolling settings
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false

# Change file manager display to list
gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'

#############
# ROOT TASKS
#############

echo ""
echo "### Upgrade to root ###"

# Upgrade to root
if [ "$(whoami)" != "root" ]
then
    sudo su -s "$0"
    exit
fi

# Install packages
add-apt-repository ppa:n-muench/programs-ppa
add-apt-repository ppa:ubuntu-wine/ppa -y
add-apt-repository universe -y
apt-get update
apt-get upgrade -y
apt-get dist-upgrade -y

# Provisional: Thunar Krename

echo "# Tools Installed by Initial Setup Script" > $listfile
echo "" > $listfile

# CLI packages
apt-get install -y htop git tree openvpn jq nmap dconf-tools ufw wine winetricks mc nethogs zip unzip screen iperf3 curl traceroute python-pip openconnect byobu iotop sysstat
echo "## Installed CLI tools" >> $listfile
echo " * htop (process manager)" >> $listfile
echo " * git (version control)" >> $listfile
echo " * openvpn (vpn)" >> $listfile
echo " * tree (directory structure viewer)" >> $listfile
echo " * jq (json formatter)" >> $listfile
echo " * nmap (network mapping tool)" >> $listfile
echo " * Wine (Windows API)" >> $listfile
echo " * Midnight Commander (CLI File Manager)" >> $listfile
echo " * NetHogs (HTOP for Network Connections)" >> $listfile
echo " * Zip and Unzip (.zip file handlers)" >> $listfile
echo " * Screen (Terminal abstraction)" >> $listfile
echo " * iperf3 (Bandwidth tester)" >> $listfile
echo " * traceroute (network path tester)" >> $listfile
echo " * PIP  (python packman)" >> $listfile
echo " * OpenConnect  (UWW VPN)" >> $listfile
echo " * BYOBU (Terminal wrapper)" >> $listfile
echo " * iotop (Disk write monitor by process)" >> $listfile
echo " * Sysstat (System statistics )" >> $listfile
echo "" >> $listfile

# Install gui packages
apt-get install -y inkscape gimp lyx audacity filezilla pdfmod cheese vlc sshuttle musescore virtualbox virt-manager scribus network-manager-openvpn shutter guake mysql-workbench retext xbindkeys xbindkeys-config remmina idjc gconf-editor indicator-weather indicator-multiload indicator-cpufreq
echo "## Installed GUI tools" >> $listfile
echo " * Inkscape (Vector Graphics)" >> $listfile
echo " * GIMP (Raster Graphics)" >> $listfile
echo " * LyX (LaTeX tool)" >> $listfile
echo " * Audacity (Audio editor)" >> $listfile
echo " * FileZilla (FTP and SFTP client)" >> $listfile
echo " * Cheese (Camera viewer)" >> $listfile
echo " * VLC (Media viewer)" >> $listfile
echo " * MuseScore (Music Engraving)" >> $listfile
echo " * Eclipse (Development)" >> $listfile
echo " * Virtualbox (VMs)" >> $listfile
echo " * Virt Manager (KVM remote tool)" >> $listfile
echo " * Scribus (Desktop typesetting)" >> $listfile
echo " * OpenVPN Network Manager Integration (GUI control for OpenVpn)" >> $listfile
echo " * Shutter (advanced screenshots)" >> $listfile
echo " * guake (advanced terminal)" >> $listfile
echo " * mySQL Workbench (a mysql development tool)" >> $listfile
echo " * ReText (markdown editor)" >> $listfile
echo " * XBindKeys (X server keystroke customizer)" >> $listfile
echo " * Remmina (RDP)" >> $listfile
echo " * Internet DJ Console" >> $listfile
echo " * Top bar weather indicator" >> $listfile
echo " * Top bar Load Watcher" >> $listfile
echo " * indicator-cpufreq (Top bar CPU clock manager)" >> $listfile

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

echo " * Chrome (Browser)" >> $listfile

# Install Slack

slackFile="https://downloads.slack-edge.com/linux_releases/slack-desktop-2.3.2-amd64.deb"
wget $slackFile -O $tempDir/slack.deb

dpkg --install $tempDir/slack.deb

if [ $? != 0 ]; then
  apt-get install -f -y;
  dpkg --install $tempDir/slack.deb;
fi

echo " * Slack (Team messaging)" >> $listfile


# Install Atom

slackFile="https://atom.io/download/deb"
wget $slackFile -O $tempDir/atom.deb

dpkg --install $tempDir/atom.deb

if [ $? != 0 ]; then
  apt-get install -f -y;
  dpkg --install $tempDir/atom.deb;
fi

echo " * Atom (Text Editor)" >> $listfile


# Install Dropbox
# No longer using, keeping code here in case I ever choose to revert

# rm  $tempDir/dropbox.deb -f
# wget https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2015.10.28_amd64.deb -O $tempDir/dropbox.deb

# dpkg --install $tempDir/dropbox.deb

# if [ $? != 0 ]; then
#   apt-get install -f -y;
#   dpkg --install $tempDir/dropbox.deb;
# fi

# restart nautilus
# nautilus -q && nautilus &

# echo " * Dropbox (File Sync)" >> $listfile


# Install OwnCloud
curl http://download.opensuse.org/repositories/isv:/ownCloud:/desktop/Ubuntu_16.04/Release.key > /tmp/owncloud-release.key

apt-key add - < /tmp/owncloud-release.key
rm /tmp/owncloud-release.key -f

sh -c "echo 'deb http://download.opensuse.org/repositories/isv:/ownCloud:/desktop/Ubuntu_16.04/ /' > /etc/apt/sources.list.d/owncloud-client.list"
apt-get update
# apt-get install owncloud-client -y
apt-get install owncloud-client -y --allow-unauthenticated

echo " * OwnCloud (File Sync)" >> $listfile

# add update features
wget http://download.opensuse.org/repositories/isv:ownCloud:desktop/Ubuntu_16.04/Release.key -O $tempDir/oc.key
sudo apt-key add - < $tempDir/oc.key
rm $tempdir/oc.key -f


# Setup sync with hard-links to NextCloud
# mkdir /home/

reownHome

# Enable UFW firewall

ufw default deny incoming
ufw default allow outgoing
ufw allow 22
ufw --force enable


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


#Add to papertrail
# If computer uses rsyslog
if [ -a /etc/rsyslog.conf ]; then
# if it doesn't already contain papertrail logging
 if ! grep -q $papertrailDest "/etc/rsyslog.conf"; then
    echo "" >> /etc/rsyslog.conf
    echo "*.*          @$papertrailDest" >> /etc/rsyslog.conf
    service rsyslog restart
  fi
fi
