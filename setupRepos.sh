#!/bin/bash

base="/home/benyanke/git"

mkdir -p $base

function getrepo() {

	mkdir -p $base/$1
	git clone git@github.com:benyanke/$1.git $base/$1

}

getrepo school-projects
getrepo configScripts
getrepo LiturgicalYearBook-Site
getrepo PublicKeys`
getrepo mvc-temp
getrepo sshuttle-control
getrepo SecureShare
getrepo NetworkRecorder
getrepo notes.benyanke.com
getrepo benyanke.github.io
getrepo ezservermonitor-sh
getrepo LinkCatAutoRenew
