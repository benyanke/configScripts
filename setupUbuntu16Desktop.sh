#!/bin/bash


# destination for papertrail logging
#example:
papertrailDest="logs12345.papertrailapp.com:12345"


# get current user, and home directory path
if [ "$USER" == "root" ]; then
  currentUser=$SUDO_USER;
else
  currentUser=$USER;
fi

# Request Sudo Access before we continue further
sudo cat /dev/null

# Delete temp directory after script finishes
set -e
function cleanup {
  echo "Removing temp directory"
  sudo rm  -rf /tmp/installfiles
}
trap cleanup EXIT


# tempDir="/home/$currentUser/temp"
tempDir="/tmp/installfiles"
homeDir="/home/$currentUser"

# This file contains a list of installed tools for user reference
listfile="$homeDir/installedtools.md"

# Version (unity or MATE)
version=$(grep cdrom: /etc/apt/sources.list | sed -n '1s|.*deb cdrom:\[\([^ ]* *[^ ]*\).*|\1|p');


# Make Temp Directory
sudo mkdir $tempDir -p
sudo chown $currentUser:$currentUser $tempDir


function reownHome() {
	chown $currentUser:$currentUser $homeDir -R
}


# Root Override Section
if [ "$1" != "-f" ] ; then
  if [ "$(whoami)" != "root" ] ; then
      echo "Starting...."
    else
     echo "Please do not run as root";
     exit 1;
  fi


  #############
  # NONROOT TASKS
  #############

  # Change Desktop

  function getBackgroundFile() {
    mkdir -p $homeDir/Pictures/DesktopBackgrounds

    filename=$1;
    desktopBgBaseUrl="https://github.com/benyanke/configScripts/raw/master/img/desktopbackgrounds";

    rm -r "$homeDir/Pictures/DesktopBackgrounds/$filename";
    wget "$desktopBgBaseUrl/$filename" -O "$homeDir/Pictures/DesktopBackgrounds/$filename";

  }



  # Function to set the desktop background
  function setDesktopBackground() {

      basepath="$homeDir/Pictures/DesktopBackgrounds/";
      desktopfile=$1;

      ##### For MATE only
      if [[ $version == *"MATE"* ]] ; then

          # Change scrolling settings
          gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false

          # Change desktop background
          gsettings set org.mate.background primary-color "rgb(0,0,0)";
          gsettings set org.mate.background picture-filename "$basepath/$desktopfile";

      ##### For Unity only
      else

          # Change scrolling settings
          gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false

          # Change file manager display to list
          gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'

          # Change menus to in the window
          gsettings set com.canonical.Unity integrated-menus true

          # Change desktop background
          gsettings set org.gnome.desktop.background picture-uri "file://$basepath/$desktopfile"

      fi
  }

  # Download files from git repo
  getBackgroundFile "cat6.jpg";
  getBackgroundFile "cloud.png";
  getBackgroundFile "inception-code.jpg";
  getBackgroundFile "knight.jpg";
  getBackgroundFile "ubuntu-blue.jpg";
  getBackgroundFile "ubuntu-grey.jpg";
  getBackgroundFile "O4GTKkE.jpg";

  # Set one to be the background
  setDesktopBackground "O4GTKkE.jpg";


  # Changing miscellaneous settings
  gsettings set org.gnome.system.proxy use-same-proxy false
  gsettings set com.canonical.indicator.datetime show-day true
  gsettings set com.canonical.indicator.datetime show-date true
  gsettings set com.canonical.indicator.datetime show-week-numbers true
  gsettings set com.canonical.Unity.Launcher favorites ['application://org.gnome.Nautilus.desktop', 'application://firefox.desktop', 'application://org.gnome.Software.desktop', 'unity://running-apps', 'application://gnome-terminal.desktop', 'unity://expo-icon', 'unity://devices', 'unity://desktop-icon']
  gsettings set org.gnome.nautilus.list-view default-visible-columns ['name', 'size', 'type', 'date_modified', 'date_accessed', 'owner', 'group', 'permissions']
  gsettings set org.gnome.nautilus.list-view default-column-order ['name', 'size', 'type', 'date_modified', 'date_accessed', 'owner', 'group', 'permissions', 'mime_type', 'where']



  echo ""
  echo "### Upgrade to root ###"

  # Upgrade to root
  if [ "$(whoami)" != "root" ]; then
      sudo $0 -f
      exit 0;
  else
      echo "Could not be upgraded to root.";
      exit 1;
  fi

else # end nonroot tasks, moving on to root

  echo "root";

  #############
  # ROOT TASKS
  #############

  # Reown the home dir before continuing
  reownHome



  # Install packages
  add-apt-repository ppa:n-muench/programs-ppa
  add-apt-repository ppa:ubuntu-wine/ppa -y
  add-apt-repository universe -y
  apt-get update
  apt-get upgrade -y
  apt-get dist-upgrade -y

  echo "# Tools Installed by Initial Setup Script" > $listfile
  echo "" > $listfile

  # CLI packages
  apt-get install -y htop git tree openvpn jq nmap dconf-tools ufw wine winetricks mc nethogs zip unzip screen iperf3 curl traceroute python-pip openconnect byobu iotop sysstat systemtap-sdt-dev ubuntu-restricted-extras
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
  echo " * systemtap-sdt-dev (Dtrace )" >> $listfile
  echo " * ubuntu-restricted-extrasv (Audio Codecs - not sure if want to keep)" >> $listfile

  echo "" >> $listfile

  # Install gui packages
  apt-get install -y inkscape gimp lyx audacity filezilla pdfmod cheese vlc sshuttle musescore virtualbox virt-manager scribus network-manager-openvpn shutter guake mysql-workbench retext xbindkeys xbindkeys-config remmina idjc gconf-editor indicator-weather indicator-multiload indicator-cpufreq fmit unity-tweak-tool gtkpod gtkpod-aac docky
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
  echo " * fmit (Music tuner)" >> $listfile
  echo " * unity-tweak-tool (Figure it out)" >> $listfile
  echo " * gtkpod (Linux iPod Sync Tool)" >> $listfile
  echo " * Docky (Dock)" >> $listfile


function installdeb() {

  deb="$1"
  wget $1 -O $tempDir/slack.deb

  dpkg --install $tempDir/slack.deb

  if [ $? != 0 ]; then
    apt-get install -f -y;
    dpkg --install $tempDir/slack.deb;
  fi

  echo " * $2 ($3)" >> $listfile

}

  # Install Chrome
  # Get dependencies
  apt-get install -y libgconf2-4 libnss3-1d libxss1
  if [ $? != 0 ]; then
    apt-get install -f -y;
    apt-get install -y libgconf2-4 libnss3-1d libxss1
  fi

  installdeb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" "Chrome" "Browser"

  # Install Slack
  installdeb "https://downloads.slack-edge.com/linux_releases/slack-desktop-2.3.2-amd64.deb"  "Slack" "Team messaging"

  # Install Atom
  installdeb "https://atom.io/download/deb" "Atom" "Text Editor"


  # Install __ Chat Client

  mkdir /opt/franz -p
  mkdir /opt/bin -p

  programArchive="https://github.com/meetfranz/franz-app/releases/download/4.0.4/Franz-linux-x64-4.0.4.tgz"
  wget $programArchive -O $tempDir/franz.tgz

  tar -xvzf $tempDir/franz.tgz -C /opt/franz

	ln -s /opt/franz/Franz /opt/bin/franz

	echo " * Franz (Multi-provider chat client)" >> $listfile


  # Install Dropbox
  # No longer using, keeping code here in case I ever choose to revert

  # installdeb "https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2015.10.28_amd64.deb" "Dropbox" "File Sync"

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
  reownHome

  exit;



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


fi # end root override
