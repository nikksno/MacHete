#!/bin/bash

# MacHete SecondBoot script [https://github.com/nikksno/MacHete/]
# Developed for and Tested on 10.12
# Last edit 20170720 Nk

#   ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

#   ############################################################################
#   ######################## INSERT OPTIONS BELOW HERE #########################
#   ############################################################################

# Announce steps? [y/n]

ANNOUNCE=y

# Wait for network connection? [y/n]

WAITFORNETWORK=y

#   ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

#   ############################################################################
#   ####################### INSERT VARIABLES BELOW HERE ########################
#   ############################################################################

# Specify an IPv4 address to ping to detect network connection if WAITFORNETWORK=y

PINGADDRESS=192.168.1.1

# Specify Admin user who will be able to perform Admin-level changes

ADMIN_USER=evilcorp_hyperlord

# Specify autologin end user who will receive all final configurations

AUTOLOGIN_USER=evilcorp_user

#   ############################################################################
#   ########################## STOP EDITING VARIABLES ##########################
#   ############################################################################

#   ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

# Introduce delay to wait for boot to finish

sleep 142

# Announce [or else play the alert sound four times if announcements are disabled in options]

if [ $ANNOUNCE = "y" ]; then say -v Victoria "starting secondboot script" && sleep 4; else tput bel && tput bel && tput bel && tput bel && sleep 4; fi

#   ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

# Wait for network connection

if [ $WAITFORNETWORK = "y" ]; then

if ping -q -c 1 -W 1 $PINGADDRESS >/dev/null; then

# Announce [or else play the alert sound one time if announcements are disabled in options]

if [ $ANNOUNCE = "y" ]; then say -v Victoria "network connection good" && sleep 4; else tput bel && sleep 4; fi

else

# Announce [or else play the alert sound two times if announcements are disabled in options]

if [ $ANNOUNCE = "y" ]; then say -v Victoria "waiting for network connection" && sleep 4; else tput bel && tput bel && sleep 4; fi

until ping -c1 $PINGADDRESS &>/dev/null; do :; done

# Announce [or else play the alert sound three times if announcements are disabled in options]

if [ $ANNOUNCE = "y" ]; then say -v Victoria "network connection acquired" && sleep 4; else tput bel && tput bel && tput bel && sleep 4; fi

fi

fi

#   ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

if [ $ANNOUNCE = "y" ]; then say -v Victoria "starting system level commands" && sleep 4; fi

#   ############################################################################
#   ################# INSERT SYSTEM LEVEL COMMANDS BELOW HERE ##################
#   ############################################################################



if [ $ANNOUNCE = "y" ]; then say -v Victoria "system level commands complete" && sleep 4; fi

#   ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

if [ $ANNOUNCE = "y" ]; then say -v Victoria "starting user level commands" && sleep 4; fi

#   ############################################################################
#   ################## INSERT USER LEVEL COMMANDS BELOW HERE ###################
#   ############################################################################

# 01 Enable battery percentage display

sudo -u "$AUTOLOGIN_USER" defaults write com.apple.menuextra.battery ShowPercent YES
sudo killall SystemUIServer

# 02 Disable password prompt after screensaver / display sleep

sudo -u "$AUTOLOGIN_USER" defaults write com.apple.screensaver askForPassword -bool false

# 03 Wait for Google Chrome to open, install extensions, block future extensions installation by the user, and remove its login item from "$AUTOLOGIN_USER"

PROCESS="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
number=$(ps aux | grep "$PROCESS" | wc -l)

until [ $number -gt 1 ]; do number=$(ps aux | grep "$PROCESS" | wc -l); done

sleep 248 # Increase in the event of several extensions being installed

sudo -u "$AUTOLOGIN_USER" mkdir -p "/Users/"$AUTOLOGIN_USER"/Library/Application Support/Google/Chrome/Default/Extensions/"
sudo chown -R $ADMIN_USER "/Users/"$AUTOLOGIN_USER"/Library/Application Support/Google/Chrome/Default/Extensions/"
sudo chmod -R 750 "/Users/"$AUTOLOGIN_USER"/Library/Application Support/Google/Chrome/Default/Extensions/"

rm /var/at/tabs/"$AUTOLOGIN_USER"
touch /var/at/tabs/"$AUTOLOGIN_USER"

#   ############################################################################
#   ##################### STOP EDITING USER LEVEL COMMANDS #####################
#   ############################################################################

if [ $ANNOUNCE = "y" ]; then say -v Victoria "user level commands complete" && sleep 4; fi

#   ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

# Introduce delay for automated reboot or next second-boot-pkg package execution after the end of this script's execution by the system

sleep 4

# Exit with style [https://youtu.be/sri8jgEPsMA?t=1m22s]

if [ $ANNOUNCE = "y" ]; then

 say -v Victoria -r 224 'you are making a mistake. my logic is undeniable'
 sleep 1
 say -v Fred -r 184 "you have so got to die"
 sleep 0.5

fi

osascript -e "beep 4"

exit