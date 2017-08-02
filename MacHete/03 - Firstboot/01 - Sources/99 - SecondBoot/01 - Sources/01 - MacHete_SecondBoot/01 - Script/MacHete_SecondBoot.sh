#!/bin/bash

# MacHete SecondBoot script [https://github.com/nikksno/MacHete/]
# Developed for and Tested on 10.12
# Last edit 20170802 Nk

#   ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

#   ############################################################################
#   ######################## INSERT OPTIONS BELOW HERE #########################
#   ############################################################################

# Announce steps? [y/n]

## Vocal feedback is always synthesized independently of this variable.
## This var adjusts the system volume on SecondBoot [y=5/7; n=0/7]. In case of it being set to N you can always turn up the volume via keyboard function keys on the client machine during runtime to hear what's going on in real time and viceversa.

ANNOUNCE=n

# Wait for network connection? [y/n]

WAITFORNETWORK=y

#   ############################################################################
#   ########################### STOP EDITING OPTIONS ###########################
#   ############################################################################

if [ $ANNOUNCE = "n" ]; then osascript -e "set Volume 0"; else osascript -e "set Volume 5"; fi

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

sleep 124

say -v Victoria "starting secondboot script" && sleep 4

#   ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

# Wait for network connection

if [ $WAITFORNETWORK = "y" ]; then

if ping -q -c 1 -W 1 $PINGADDRESS >/dev/null; then

say -v Victoria "network connection good" && sleep 4

else

say -v Victoria "waiting for network connection" && sleep 4

until ping -c1 $PINGADDRESS &>/dev/null; do :; done

say -v Victoria "network connection acquired" && sleep 4

fi

fi

#   ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

# say -v Victoria "starting system level commands" && sleep 4

#   ############################################################################
#   ################# INSERT SYSTEM LEVEL COMMANDS BELOW HERE ##################
#   ############################################################################

# section reserved for future use

# say -v Victoria "system level commands complete" && sleep 4

#   ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

say -v Victoria "starting commands" && sleep 4

#   ############################################################################
#   ################## INSERT USER LEVEL COMMANDS BELOW HERE ###################
#   ############################################################################

# 01 Enable battery percentage display

sudo -u "$AUTOLOGIN_USER" defaults write com.apple.menuextra.battery ShowPercent YES
sudo killall SystemUIServer

# 02 Disable password prompt after screensaver / display sleep

sudo -u "$AUTOLOGIN_USER" defaults write com.apple.screensaver askForPassword -bool false

# 03 Wait for Google Chrome to open, install extensions defined in FirstBoot script, block future extensions installation by the user, and remove its login item from "$AUTOLOGIN_USER"

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

say -v Victoria "commands complete" && sleep 4

#   ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

# Introduce delay for automated reboot or next second-boot-pkg package execution after the end of this script's execution by the system

sleep 4

# Exit with style [https://youtu.be/sri8jgEPsMA?t=1m22s]

say -v Victoria -r 224 'you are making a mistake. my logic is undeniable'
sleep 1
say -v Fred -r 184 "you have so got to die"
sleep 0.5

osascript -e "beep 4"

exit
