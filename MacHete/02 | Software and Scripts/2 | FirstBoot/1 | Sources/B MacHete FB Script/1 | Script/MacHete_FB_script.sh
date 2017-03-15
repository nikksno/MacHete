#!/bin/bash

# MacHete FirstBoot script [https://github.com/nikksno/MacHete/]

# Last edit 20170222 Nk

#################################
### INSERT OPTIONS BELOW HERE ###
#################################

# Announce steps? [y/n]

ANNOUNCE=y

# Wait for network connection? [y/n]

WAITFORNETWORK=y

# Set autologin user? [y/n] [overrides setting from create-user-pkg]

SETAUTOLOGIN=y

#################################
##### STOP EDITING OPTIONS ######
#################################

###################################
### INSERT VARIABLES BELOW HERE ###
###################################

# Specify an IPv4 address to ping to detect network connection if WAITFORNETWORK=y

PINGADDRESS=8.8.8.8

# List user[s] created via create-user-pkg or DEP/ASM [NOT via initial setup] for two reasons:

## To avoid false positives when detecting completion of the user creation during the initial setup on the client by the end user
## To know which users to always apply user-level commands to

USER1=evilcorp-user
USER2=null
USER3=null

# If you have a user that is frequently or always crated via the initial setup list its name here to also apply user-level commands to it.
# Note that user-level commands will not apply to users NOT matching USER1, USER2, USER3, or ADDITIONALUSER

ADDITIONALUSER=evilcorp-admin

# Set the autologin user if SETAUTOLOGIN=y

AUTOLOGINUSER=evilcorp-user

###################################
##### STOP EDITING VARIABLES ######
###################################

# Introduce delay to avoid audio conflict with Voiceover announcement

sleep 42

# Announce

if [ $ANNOUNCE = "y" ]; then say -v Victoria "starting firstboot script"; fi

sleep 4

# Wait for network connection

if [ $WAITFORNETWORK = "y" ]; then

if ping -q -c 1 -W 1 $PINGADDRESS >/dev/null; then

if [ $ANNOUNCE = "y" ]; then say -v Victoria "network connection good"; fi

else

if [ $ANNOUNCE = "y" ]; then say -v Victoria "waiting for network connection"; fi

until ping -c1 $PINGADDRESS &>/dev/null; do :; done

if [ $ANNOUNCE = "y" ]; then say -v Victoria "network connection acquired"; fi

fi

fi

###############################################
### INSERT SYSTEM LEVEL COMMANDS BELOW HERE ###
###############################################

# 01 Disable GateKeeper

sudo spctl --master-disable

# 02 Set time zone automatically using current location

sudo /usr/bin/defaults write /Library/Preferences/com.apple.timezone.auto Active -bool true

# 03 Require an admin password to unlock each system preferences pane

sudo security authorizationdb read system.preferences > /tmp/system.preferences.plist
sudo defaults write /tmp/system.preferences.plist shared -bool false
sudo security authorizationdb write system.preferences < /tmp/system.preferences.plist
sudo rm /tmp/system.preferences.plist

# 04 Disable non-admin WiFi network change

sudo /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport en0 prefs RequireAdminIBSS=YES RequireAdminNetworkChange=YES RequireAdminPowerToggle=YES
sudo /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport en1 prefs RequireAdminIBSS=YES RequireAdminNetworkChange=YES RequireAdminPowerToggle=YES
sudo /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport en2 prefs RequireAdminIBSS=YES RequireAdminNetworkChange=YES RequireAdminPowerToggle=YES

# 05 Enable NoSleep at 15:42 every day [if the mac is awake at that time to actually execute this cronjob - this is intentional] and keep awake for scheduled updates from the ARD server until 20:32 [scheduled shutdown time] + 10 minutes [scheduled shutdown pre-alert time], after which disable NoSleep at 20:56 in case of missed scheduled shutdown. Also disable NoSleep after reboot.

sudo touch /var/at/tabs/root
echo "echo '42 15 * * * /usr/local/bin/NoSleepCtrl -abs 1,1 && sleep 4 && /usr/local/bin/NoSleepCtrl -abs 1,1 && sleep 4 && /usr/local/bin/NoSleepCtrl -abs 1,1 && caffeinate -t 18840 && /usr/local/bin/NoSleepCtrl -abs 0,0' > /var/at/tabs/root" | sudo bash
echo "echo '@reboot sleep 108 && /usr/local/bin/NoSleepCtrl -abs 0,0' >> /var/at/tabs/root" | sudo bash
sudo crontab /var/at/tabs/root

# 06 Disable Adobe Flash player updater

sudo touch /Library/Application\ Support/Macromedia/mms.cfg
echo "echo 'AutoUpdateDisable=1' > /Library/Application\ Support/Macromedia/mms.cfg" | sudo bash
echo "echo 'SilentAutoUpdateEnable=0' >> /Library/Application\ Support/Macromedia/mms.cfg" | sudo bash

# 07 Install one-sided printers [drivers and driver substitutions in image]

# Here we replace the drivers in question with their substitutes and then actually install the printers
# To install two-sided printers [driver default] disable driver substitutions on the next two lines by commenting them out

sudo mv /Library/Printers/PPDs/Contents/Resources/KONICAMINOLTA454e-1sided.gz /Library/Printers/PPDs/Contents/Resources/KONICAMINOLTA454e.gz
sudo mv /Library/Printers/PPDs/Contents/Resources/KONICAMINOLTAC364e-1sided.gz /Library/Printers/PPDs/Contents/Resources/KONICAMINOLTAC364e.gz

sudo lpadmin -p StaffRoom_Printer_Left_v2 -D "StaffRoom Printer Left v2" -L "evilcorp Staff Room" -E -v lpd://192.168.0.111 -P /Library/Printers/PPDs/Contents/Resources/KONICAMINOLTA454e.gz
sudo lpadmin -p StaffRoom_Printer_Right_v2 -D "StaffRoom Printer Right v2" -L "evilcorp Staff Room" -E -v lpd://192.168.0.112 -P /Library/Printers/PPDs/Contents/Resources/KONICAMINOLTA454e.gz
sudo lpadmin -p GroundFloor_Printer_Colour_v2 -D "GroundFloor Printer Colour v2" -L "evilcorp Ground Floor" -E -v lpd://192.168.0.113 -P /Library/Printers/PPDs/Contents/Resources/KONICAMINOLTAC364e.gz

##########################################
### STOP EDITING SYSTEM LEVEL COMMANDS ###
##########################################

# Announce

if [ $ANNOUNCE = "y" ]; then say -v Victoria "system level commands complete"; fi

sleep 4

# Wait for Initial Setup to be completed by the user

while [ ! -f /var/db/.AppleSetupDone ]
do
sleep 1
done

# Announce

if [ $ANNOUNCE = "y" ]; then say -v Victoria "setup complete"; fi

sleep 4

# Wait for User[s] creation to be complete

usersnumber=$(dscl . list /users shell | grep -v false | grep -v _ | grep -v root | grep -v $USER1 | grep -v $USER2 | grep -v $USER3 | wc -l | tr -d " \t\r")

while [[ $usersnumber == 0 ]]
do
sleep 1
usersnumber=$(dscl . list /users shell | grep -v false | grep -v _ | grep -v root | grep -v $USER1 | grep -v $USER2 | grep -v $USER3 | wc -l | tr -d " \t\r")
done

# Announce

if [ $ANNOUNCE = "y" ]; then say -v Victoria "user creation complete"; fi

sleep 32

# Perform user-specific actions since user has now been created

# Announce

if [ $ANNOUNCE = "y" ]; then say -v Victoria "starting user level commands"; fi

sleep 4

#############################################
### INSERT USER LEVEL COMMANDS BELOW HERE ###
#############################################

# 01 Set autologin user

if [ $SETAUTOLOGIN = "y" ]; then sudo defaults write /Library/Preferences/com.apple.loginwindow autoLoginUser "$AUTOLOGINUSER"; fi

# 02 Enable battery percentage display in menu battery

sudo -u $USER1 defaults write com.apple.menuextra.battery ShowPercent YES
sudo -u $USER2 defaults write com.apple.menuextra.battery ShowPercent YES
sudo -u $USER3 defaults write com.apple.menuextra.battery ShowPercent YES
sudo -u $ADDITIONALUSER defaults write com.apple.menuextra.battery ShowPercent YES
sudo killall SystemUIServer

########################################
### STOP EDITING USER LEVEL COMMANDS ###
########################################

# Announce

if [ $ANNOUNCE = "y" ]; then say -v Victoria "user level commands complete"; fi

# Introduce delay for automated reboot after the end of this script's execution by the system

sleep 4

# Announce computer ready

if [ $ANNOUNCE = "y" ]; then say -v Victoria "computer ready"; fi

# Exit script

exit
