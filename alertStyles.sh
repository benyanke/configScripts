#!/bin/bash

apt-get install boxes notify-send -y
echo "test" | boxes
notify-send 'title' 'message'


#You also can use zenity for a popup window:

zenity --error --text="An error occurred\!" --title="Warning\!"

#Zenity is more graphical and has more options, like having the window appear as q question, using:

zenity --question --text="Do you wish to continue/?"

#or even progress bars, using:

find /usr | zenity --progress --pulsate --auto-close --auto-kill --text="Working..."
#zenity looks like this:


# http://unix.stackexchange.com/questions/144924/creating-a-messagebox-using-commandline
