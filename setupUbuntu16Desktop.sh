#!/bin/bash

# Todo:
# APT BROKEN: Jack audio question asked upon install
# Microsoft fonts issue as well
# SSH SERVER + keys
# Add guake, docky, etc, to ubuntu startup scripts

# Add nextcloud setup
# Add config sync system
# Setup guake config
# Look into gnome config
# Dockyconf
# Git repos
# Scripts folder
# http://www.omgubuntu.co.uk/2016/09/wunderline-nifty-command-line-app-wunderlist


# destination for papertrail logging
#example:
papertrailDest="logs12345.papertrailapp.com:12345"

inslog="/tmp/installlog"; # install log
echo "Install Log" > $inslog
echo "" > $inslog
echo "" > $inslog


curStep=""; # current step
function step() {
  curStep="$1"
  echo " [      ] $curStep";
}

function stepdone() {
  echo -en "\e[1A"
  echo -e " [ \e[92mDONE\e[0m ] $curStep"
}


function error() {
  echo "ERROR: $1";
}


# get current user, and home directory path
if [ "$USER" == "root" ]; then
  currentUser=$SUDO_USER;
else
  currentUser=$USER;
fi

# Request Sudo Access before we continue further
sudo cat /dev/null

# Delete temp directory after script finishes
# set -e
# function cleanup {
#  echo "Removing temp directory"
#  sudo rm  -rf /tmp/installfiles
# }
# trap cleanup EXIT

# tempDir="/home/$currentUser/temp"
tempDir="/tmp/installfiles"
homeDir="/home/$currentUser"

# This file contains a list of installed tools for user reference
listfile="$homeDir/installedtools.md"

# Version (unity or MATE)
version=$(grep cdrom: /etc/apt/sources.list | sed -n '1s|.*deb cdrom:\[\([^ ]* *[^ ]*\).*|\1|p');


# Make Temp Directory
sudo mkdir $tempDir -p > $inslog 2>&1
sudo chown $currentUser:$currentUser $tempDir > $inslog 2>&1


function reownHome() {
	chown $currentUser:$currentUser $homeDir -R > $inslog 2>&1
}


# Root Override Section
if [ "$1" != "-f" ] ; then
  if [ "$(whoami)" != "root" ] ; then
      echo "Starting...." > $inslog 2>&1
    else
     echo "Please do not run as root";
     exit 1;
  fi


  #############
  # NONROOT TASKS
  #############

  # Change Desktop

  function getBackgroundFile() {
    mkdir -p $homeDir/Pictures/DesktopBackgrounds> $inslog 2>&1

    filename=$1;> $inslog 2>&1
    desktopBgBaseUrl="https://github.com/benyanke/configScripts/raw/master/img/desktopbackgrounds"> $inslog 2>&1

    rm -r "$homeDir/Pictures/DesktopBackgrounds/$filename" > $inslog 2>&1
    wget "$desktopBgBaseUrl/$filename" -O "$homeDir/Pictures/DesktopBackgrounds/$filename" > $inslog 2>&1
  }



  # Function to set the desktop background
  function setDesktopBackground() {
      basepath="$homeDir/Pictures/DesktopBackgrounds/" > $inslog 2>&1
      desktopfile=$1 > $inslog 2>&1

      # Allow VNC connections over localhost
      gsettings set org.gnome.Vino network-interface lo > $inslog 2>&1

      ##### For MATE only
      if [[ $version == *"MATE"* ]] ; then

          # Change scrolling settings
          gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false > $inslog 2>&1

          # Change desktop background
          gsettings set org.mate.background primary-color "rgb(0,0,0)" > $inslog 2>&1
          gsettings set org.mate.background picture-filename "$basepath/$desktopfile" > $inslog 2>&1

      ##### For Unity only
      else

          # Change scrolling settings
          gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false > $inslog 2>&1

          # Change file manager display to list
          gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view' > $inslog 2>&1

          # Change menus to in the window
          gsettings set com.canonical.Unity integrated-menus true > $inslog 2>&1

          # Change desktop background
          gsettings set org.gnome.desktop.background picture-uri "file://$basepath/$desktopfile" > $inslog 2>&1

      fi
  }

  # Download files from git repo
  step "Downloading Desktop Backgrounds"
  getBackgroundFile "cat6.jpg"
  getBackgroundFile "cloud.png";
  getBackgroundFile "inception-code.jpg"
  getBackgroundFile "knight.jpg";
  getBackgroundFile "ubuntu-blue.jpg";
  getBackgroundFile "ubuntu-grey.jpg";
  getBackgroundFile "O4GTKkE.jpg";
  stepdone

  # Set one to be the background
  step "Setting desktop background"
  setDesktopBackground "O4GTKkE.jpg";
  stepdone




  # Changing miscellaneous settings
  step "Configuring Display Manager"
  gsettings set com.canonical.Unity integrated-menus true
  gsettings set com.canonical.Unity integrated-menus false
  gsettings set org.gnome.system.proxy use-same-proxy false
  gsettings set com.canonical.indicator.datetime show-day true
  gsettings set com.canonical.indicator.datetime show-date true
  gsettings set com.canonical.indicator.datetime show-week-numbers true
  stepdone;


#  echo ""
#  echo "### Upgrade to root ###"

  # Upgrade to root
  if [ "$(whoami)" != "root" ]; then
      sudo $0 -f
      exit 0;
  else
      error "Could not be upgraded to root.";
      exit 1;
  fi

else # end nonroot tasks, moving on to root


  #############
  # ROOT TASKS
  #############

  # Reown the home dir before continuing
  reownHome



  # Install packages

  # Not sure what this does
#  add-apt-repository ppa:n-muench/programs-ppa -y

  step "Adding APT PPA repositories"

  # Get WINE
  add-apt-repository ppa:ubuntu-wine/ppa -y > $inslog 2>&1

  # Get most recent shutter version
  add-apt-repository ppa:shutter/ppa -y > $inslog 2>&1

  # NextCloud
  add-apt-repository ppa:nextcloud-devs/client -y > $inslog 2>&1

  # Weather widget
  add-apt-repository ppa:kasra-mp/ubuntu-indicator-weather -y > $inslog 2>&1

  # Get expanded ubuntu list
  add-apt-repository universe -y > $inslog 2>&1

  stepdone

  step "Updating APT List"
  apt-get update > $inslog 2>&1
  stepdone

  step "Upgrading APT Packages"
  apt-get upgrade -y > $inslog 2>&1
  apt-get dist-upgrade -y > $inslog 2>&1
  stepdone

  step "Installing APT packages"
  echo "# Tools Installed by Initial Setup Script" > $listfile
  echo "" > $listfile

  # CLI packages
  apt-get install -y htop git tree openvpn jq nmap dconf-tools ufw mc nethogs zip unzip screen iperf3 curl traceroute python-pip openconnect byobu iotop sysstat systemtap-sdt-dev ubuntu-restricted-extras latexmk markdown iftop espeak openssh-server wakeonlan taskwarrior > $inslog 2>&1
  echo "## Installed CLI tools" >> $listfile
  echo " * htop (process manager)" >> $listfile
  echo " * git (version control)" >> $listfile
  echo " * openvpn (vpn)" >> $listfile
  echo " * tree (directory structure viewer)" >> $listfile
  echo " * jq (json formatter)" >> $listfile
  echo " * nmap (network mapping tool)" >> $listfile
#  echo " * Wine and winetricks (Windows API)" >> $listfile
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
  echo " * latexmk (Latex Processor )" >> $listfile
  echo " * markdown (Markdown -> HTML processor)" >> $listfile
  echo " * iftop (Net Interface TOP)" >> $listfile
  echo " * espeak (text to speech)" >> $listfile
  echo " * openssh-server (SSH)" >> $listfile
  echo " * wakeonlan (Wake on Lan Server)" >> $listfile
  echo " * taskwarrior (Task Management)" >> $listfile
  echo "" >> $listfile

  # Install gui packages
  apt-get install -y inkscape gimp lyx audacity pdfmod cheese vlc sshuttle virt-manager scribus network-manager-openvpn shutter guake mysql-workbench retext xbindkeys xbindkeys-config remmina idjc gconf-editor indicator-weather indicator-multiload indicator-cpufreq fmit unity-tweak-tool docky guake gnome-todo gnome-calendar indicator-multiload  indicator-cpufreq sqlite sqlitebrowser gnome-disk-utility vino pdfsam corebird docky nextcloud-client  gnome-todo  gnome-calendar thunar gtk-recordmydesktop > $inslog 2>&1
  echo "## Installed GUI tools" >> $listfile
  echo " * Inkscape (Vector Graphics)" >> $listfile
  echo " * GIMP (Raster Graphics)" >> $listfile
  echo " * LyX (LaTeX tool)" >> $listfile
  echo " * Audacity (Audio editor)" >> $listfile
#  echo " * FileZilla (FTP and SFTP client)" >> $listfile
  echo " * Cheese (Camera viewer)" >> $listfile
  echo " * VLC (Media viewer)" >> $listfile
#  echo " * MuseScore (Music Engraving)" >> $listfile
  echo " * Eclipse (Development)" >> $listfile
#  echo " * Virtualbox (VMs)" >> $listfile
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
#  echo " * gtkpod (Linux iPod Sync Tool)" >> $listfile
  echo " * Docky (Dock)" >> $listfile
  echo " * Guake (Dropdown Terminal)" >> $listfile
  echo " * Gnome: Todo (Gnome's Todo Utility)" >> $listfile
  echo " * Gnome: Calendar (Gnome's Calendar Utility)" >> $listfile
  echo " * Indicator - Multiload (Top Bar Load Tracking)" >> $listfile
  echo " * Indicator - CPUfreq (CPU Frequency Indicator for GNOME bar - also adjusts the speed)" >> $listfile
  echo " * sqlite (SQLite DB)" >> $listfile
  echo " * sqlitebrowser (SQLite DB Browser)" >> $listfile
  echo " * gnome-disk-utility (Gnome Disk Utility)" >> $listfile
  echo " * vino (VNC Server)" >> $listfile
  echo " * pdfsam (PDF Split and Merge)" >> $listfile
  echo " * corebird (Twitter client)" >> $listfile
  echo " * docky (Dock)" >> $listfile
  echo " * nextcloud-client (NextCloud Desktop Sync)" >> $listfile
  echo " * gnome-todo (Gnome Todo List)" >> $listfile
  echo " * gnome-calendar (Gnome Calendar Program)" >> $listfile
  echo " * thunar (Alternate file manager)" >> $listfile
  echo " * gtk-recordmydesktop (Desktop recording software)" >> $listfile


  stepdone


function setstartup() {

  cp /usr/share/applications/$1.desktop ~/.config/autostart/ > $inslog 2>&1

}
  step "Adding startup apps"
  setstartup "guake"
  setstartup "indicator-multiload"
  setstartup "indicator-weather"
  setstartup "Nextcloud"
  stepdone

function installdeb() {
  step "Installing $2 from *.deb file"
  deb="$1"
  wget $1 -O $tempDir/$2.deb > $inslog 2>&1

  dpkg --install $tempDir/$2.deb > $inslog 2>&1

  if [ $? != 0 ]; then
    apt-get install -f -y  > $inslog 2>&1
    dpkg --install $tempDir/$2.deb > $inslog 2>&1
  fi

  echo " * $2 ($3)" >> $listfile
  stepdone
}

  step "Installing Chrome Dependencies"
  apt-get install -y libgconf2-4 libnss3-1d libxss1 > $inslog 2>&1
  if [ $? != 0 ]; then
    apt-get install -f -y > $inslog 2>&1
    apt-get install -y libgconf2-4 libnss3-1d libxss1 > $inslog 2>&1
  fi
  stepdone

  installdeb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" "Chrome" "Browser"

  # Install Slack
  installdeb "https://downloads.slack-edge.com/linux_releases/slack-desktop-2.3.2-amd64.deb"  "Slack" "Team messaging"

  # Install Atom
  installdeb "https://atom.io/download/deb" "Atom" "Text Editor"


  # Install Franz Chat Client
  # Disabled for now - keeping for legacy purposes
#  mkdir /opt/franz -p
#  mkdir /opt/bin -p

#  programArchive="https://github.com/meetfranz/franz-app/releases/download/4.0.4/Franz-linux-x64-4.0.4.tgz"
#  wget $programArchive -O $tempDir/franz.tgz

#  tar -xvzf $tempDir/franz.tgz -C /opt/franz

#	ln -s /opt/franz/Franz /opt/bin/franz

#	echo " * Franz (Multi-provider chat client)" >> $listfile


  # Install Dropbox
  # Disabled for now - keeping for legacy purposes
  # installdeb "https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2015.10.28_amd64.deb" "Dropbox" "File Sync"

  # TODO: Setup sync with hard-links to NextCloud

  reownHome

  # Enable UFW firewall


  step "Configuring UFW (block all !22)"
  ufw default deny incoming > $inslog 2>&1
  ufw default allow outgoing > $inslog 2>&1
  ufw allow 22 > $inslog 2>&1
  ufw --force enable > $inslog 2>&1
  stepdone

  # Upgrade all packages before finishing
  step "Update and Upgrade All APT Packages Again"
  apt-get update > $inslog 2>&1
  apt-get upgrade -y > $inslog 2>&1
  apt-get dist-upgrade -y > $inslog 2>&1
  stepdone


  step "Configuring multiload"

  gsettings set de.mh21.indicator-multiload.general speed uint16 300 > $inslog 2>&1
  gsettings set de.mh21.indicator-multiload.general width uint16 60 > $inslog 2>&1
  gsettings set de.mh21.indicator-multiload.graphs.disk enabled true > $inslog 2>&1
  gsettings set de.mh21.indicator-multiload.graphs.net enabled true > $inslog 2>&1
  gsettings set de.mh21.indicator-multiload.graphs.swap enabled true > $inslog 2>&1
  gsettings set de.mh21.indicator-multiload.graphs.mem enabled true > $inslog 2>&1
  gsettings set de.mh21.indicator-multiload.graphs.load enabled true > $inslog 2>&1

  stepdone


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
