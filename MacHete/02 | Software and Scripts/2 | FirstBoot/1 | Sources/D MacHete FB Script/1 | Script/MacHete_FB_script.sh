#!/bin/bash

# MacHete FirstBoot script [https://github.com/nikksno/MacHete/]

# Last edit 20170418 Nk

#   ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

#   ############################################################################
#   ######################## INSERT OPTIONS BELOW HERE #########################
#   ############################################################################

# Announce steps? [y/n]

ANNOUNCE=n

# Wait for network connection? [y/n]

WAITFORNETWORK=y

# Set autologin user? [y/n] [overrides any setting from create-user-pkg]

SETAUTOLOGIN=y

# Initial Setup disabled in image? [set to y if the image has the /var/db/.AppleSetupDone file included in it to make the client skip the initial setup by the user] [set to "a" for autodetection]

INITIALSETUPDISABLED=a

#   ############################################################################
#   ########################### STOP EDITING OPTIONS ###########################
#   ############################################################################

if [ $INITIALSETUPDISABLED = "a" ]; then

if [ -f "/var/db/.AppleSetupDone" ]; then

INITIALSETUPDISABLED=y

else

INITIALSETUPDISABLED=n

fi

fi

#   ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

#   ############################################################################
#   ####################### INSERT VARIABLES BELOW HERE ########################
#   ############################################################################

# Specify an IPv4 address to ping to detect network connection if WAITFORNETWORK=y

PINGADDRESS=192.168.1.1

# Set the autologin user if SETAUTOLOGIN=y

AUTOLOGINUSER=evilcorp-generic_enslaved_individual

# User settings [two cases based on the INITIALSETUPDISABLED variable]

if [ $INITIALSETUPDISABLED = "n" ]; then # DO NOT EDIT THIS LINE

#    –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– ––
#   | USER SETTINGS in case of INITIALSETUPDISABLED=n – otherwise see below    |
#    –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– ––

# List user[s] created via create-user-pkg already inside image or DEP/ASM [NOT via initial setup] for two reasons:

## To avoid false positives when detecting completion of the user creation during the initial setup on the client by the end user
## To know which users to always apply user-level commands to

USER1=evilcorp-generic_enslaved_individual
USER2=evilcorp-human_intelligence_worker
USER3=null

# If you have a user that is frequently or always crated via the initial setup list its name here to also apply user-level commands to it.
# Note that user-level commands will not apply to users NOT matching USER1, USER2, USER3, or ADDITIONALUSER

ADDITIONALUSER=evilcorp-lord_of_dystopia

else # DO NOT EDIT THIS LINE

#    –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– ––
#   | USER SETTINGS in case of INITIALSETUPDISABLED=y - otherwise see above    |
#    –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– ––

# List user[s] already created inside the image to know which user[s] to always apply user-level commands to:

USER1=evilcorp-lord_of_dystopia
USER2=evilcorp-generic_enslaved_individual
USER3=evilcorp-human_intelligence_worker

ADDITIONALUSER=null # DO NOT EDIT THIS LINE

fi # DO NOT EDIT THIS LINE

#   ############################################################################
#   ########################## STOP EDITING VARIABLES ##########################
#   ############################################################################

#   ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

# Introduce delay to avoid audio conflict with Voiceover announcement

if [ $INITIALSETUPDISABLED = "n" ]; then

sleep 42

fi

# Announce [or else play the alert sound four times if announcements are disabled in options]

if [ $ANNOUNCE = "y" ]; then say -v Victoria "starting firstboot script" && sleep 4; else tput bel && tput bel && tput bel && tput bel && sleep 4; fi

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

#    –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– ––
#   | If INITIALSETUPDISABLED=y [see explanation in options section]           |
#   | Run commands that replace user interaction                               |
#   | [that would otherwise take place during Initial Setup]                   |
#    –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– ––

if [ $INITIALSETUPDISABLED = "y" ]; then

if [ $ANNOUNCE = "y" ]; then say -v Victoria "starting setup level commands" && sleep 4; fi

#   ############################################################################
#   ################## INSERT SETUP LEVEL COMMANDS BELOW HERE ##################
#   ############################################################################

# 01 Set Locale + Country + Keyboard Layout

# [Nothing f***ing works so nevermind for now] | FIX !!!

# 02 Set system language

sudo languagesetup -langspec 1

# 03 Enable location services

sudo /bin/launchctl unload /System/Library/LaunchDaemons/com.apple.locationd.plist
sudo /usr/bin/defaults write /var/db/locationd/Library/Preferences/ByHost/com.apple.locationd LocationServicesEnabled -int 1
sudo chown -R _locationd:_locationd /var/db/locationd
sudo /bin/launchctl load /System/Library/LaunchDaemons/com.apple.locationd.plist

# 04 Set time zone automatically using current location

sudo /usr/bin/defaults write /Library/Preferences/com.apple.timezone.auto Active -bool true

#   ############################################################################
#   #################### STOP EDITING SETUP LEVEL COMMANDS #####################
#   ############################################################################

if [ $ANNOUNCE = "y" ]; then say -v Victoria "setup level commands complete" && sleep 4; fi

fi

#   ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

if [ $ANNOUNCE = "y" ]; then say -v Victoria "starting system level commands" && sleep 4; fi

#   ############################################################################
#   ################# INSERT SYSTEM LEVEL COMMANDS BELOW HERE ##################
#   ############################################################################

# 01 Disable GateKeeper

sudo spctl --master-disable

# 02 Require an admin password to unlock each system preferences pane

sudo security authorizationdb read system.preferences > /tmp/system.preferences.plist
sudo defaults write /tmp/system.preferences.plist shared -bool false
sudo security authorizationdb write system.preferences < /tmp/system.preferences.plist
sudo rm /tmp/system.preferences.plist

# 03 Disable non-admin WiFi network change

sudo /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport en0 prefs RequireAdminIBSS=YES RequireAdminNetworkChange=YES RequireAdminPowerToggle=YES
sudo /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport en1 prefs RequireAdminIBSS=YES RequireAdminNetworkChange=YES RequireAdminPowerToggle=YES
sudo /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport en2 prefs RequireAdminIBSS=YES RequireAdminNetworkChange=YES RequireAdminPowerToggle=YES

# 04 Enable all AutoUpdates

sudo softwareupdate --schedule off
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticCheckEnabled -bool YES
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticDownload -bool YES
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist ConfigDataInstall -bool YES
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist CriticalUpdateInstall -bool YES
sudo defaults write /Library/Preferences/com.apple.commerce.plist AutoUpdateRestartRequired -bool YES
sudo defaults write /Library/Preferences/com.apple.commerce.plist AutoUpdate -bool YES

# 05 Enable NoSleep [if so include program in Image] at 15:42 every day [if the mac is awake at that time to actually execute this cronjob - this is intentional] and keep awake for scheduled updates from the ARD server until 20:32 [scheduled shutdown time] + 10 minutes [scheduled shutdown pre-alert time], after which disable NoSleep at 20:56 in case of missed scheduled shutdown. Also disable NoSleep after reboot.

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

sudo lpadmin -p 378_Printer_V31S -D "378 Printer V31S" -L "evilcorp cubicle 378" -E -v lpd://192.168.201.1 -P /Library/Printers/PPDs/Contents/Resources/KONICAMINOLTA454e.gz
sudo lpadmin -p 492_Printer_V31S -D "492 Printer V31S" -L "evilcorp lab 492" -E -v lpd://192.168.201.2 -P /Library/Printers/PPDs/Contents/Resources/KONICAMINOLTA454e.gz
sudo lpadmin -p 825_Printer_V31S -D "825 Printer V31S" -L "evilcorp jail 825" -E -v lpd://192.168.201.3 -P /Library/Printers/PPDs/Contents/Resources/KONICAMINOLTAC364e.gz

#   ############################################################################
#   #################### STOP EDITING SYSTEM LEVEL COMMANDS ####################
#   ############################################################################

if [ $ANNOUNCE = "y" ]; then say -v Victoria "system level commands complete" && sleep 4; fi

#   ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

if [ $INITIALSETUPDISABLED = "n" ]; then

# Wait for Initial Setup to be completed by the user

while [ ! -f /var/db/.AppleSetupDone ]
do
sleep 1
done

if [ $ANNOUNCE = "y" ]; then say -v Victoria "setup complete" && sleep 4; fi

# Wait for User[s] creation to be complete

usersnumber=$(dscl . list /users shell | grep -v false | grep -v _ | grep -v root | grep -v $USER1 | grep -v $USER2 | grep -v $USER3 | wc -l | tr -d " \t\r")

while [[ $usersnumber == 0 ]]
do
sleep 1
usersnumber=$(dscl . list /users shell | grep -v false | grep -v _ | grep -v root | grep -v $USER1 | grep -v $USER2 | grep -v $USER3 | wc -l | tr -d " \t\r")
done

if [ $ANNOUNCE = "y" ]; then say -v Victoria "user creation complete" && sleep 32; fi

# Perform user-specific actions since user has now been created

fi

if [ $ANNOUNCE = "y" ]; then say -v Victoria "starting user level commands" && sleep 4; fi

#   ############################################################################
#   ################## INSERT USER LEVEL COMMANDS BELOW HERE ###################
#   ############################################################################

# 01 Set autologin user

if [ $SETAUTOLOGIN = "y" ]; then sudo defaults write /Library/Preferences/com.apple.loginwindow autoLoginUser "$AUTOLOGINUSER"; fi

# 02 Enable battery percentage display in menu battery

sudo -u $USER1 defaults write com.apple.menuextra.battery ShowPercent YES
sudo -u $USER2 defaults write com.apple.menuextra.battery ShowPercent YES
sudo -u $USER3 defaults write com.apple.menuextra.battery ShowPercent YES
sudo -u $ADDITIONALUSER defaults write com.apple.menuextra.battery ShowPercent YES
sudo killall SystemUIServer

# 03 Disable iCloud, Diagnostics, and Siri user-level initial setup prompt for all users
# https://github.com/rtrouton/rtrouton_scripts/blob/master/rtrouton_scripts/disable_apple_icloud_diagnostic_and_siri_pop_ups/disable_apple_icloud_diagnostic_and_siri_pop_ups.sh

osvers=$(sw_vers -productVersion | awk -F. '{print $2}')
sw_vers=$(sw_vers -productVersion)

sw_build=$(sw_vers -buildVersion)

if [[ ${osvers} -ge 7 ]]; then

 for USER_TEMPLATE in "/System/Library/User Template"/*
  do
    /usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant DidSeeCloudSetup -bool TRUE
    /usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant GestureMovieSeen none
    /usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant LastSeenCloudProductVersion "${sw_vers}"
    /usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant LastSeenBuddyBuildVersion "${sw_build}"
    /usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant DidSeeSiriSetup -bool TRUE
  done

 for USER_HOME in /Users/*
  do
    USER_UID=`basename "${USER_HOME}"`
    if [ ! "${USER_UID}" = "Shared" ]; then
      if [ ! -d "${USER_HOME}"/Library/Preferences ]; then
        /bin/mkdir -p "${USER_HOME}"/Library/Preferences
        /usr/sbin/chown "${USER_UID}" "${USER_HOME}"/Library
        /usr/sbin/chown "${USER_UID}" "${USER_HOME}"/Library/Preferences
      fi
      if [ -d "${USER_HOME}"/Library/Preferences ]; then
        /usr/bin/defaults write "${USER_HOME}"/Library/Preferences/com.apple.SetupAssistant DidSeeCloudSetup -bool TRUE
        /usr/bin/defaults write "${USER_HOME}"/Library/Preferences/com.apple.SetupAssistant GestureMovieSeen none
        /usr/bin/defaults write "${USER_HOME}"/Library/Preferences/com.apple.SetupAssistant LastSeenCloudProductVersion "${sw_vers}"
        /usr/bin/defaults write "${USER_HOME}"/Library/Preferences/com.apple.SetupAssistant LastSeenBuddyBuildVersion "${sw_build}"
        /usr/bin/defaults write "${USER_HOME}"/Library/Preferences/com.apple.SetupAssistant DidSeeSiriSetup -bool TRUE
        /usr/sbin/chown "${USER_UID}" "${USER_HOME}"/Library/Preferences/com.apple.SetupAssistant.plist
      fi
    fi
  done
fi

# 04 Disable Chrome extension installation unless logged in [at which point GSUITE domain policy kicks in]

# Work in progress...

# sudo chown -R besadmin "/Users/besuser/Library/Application Support/Google/Chrome/Default/Extensions/"
# sudo chmod -R 750 "/Users/besuser/Library/Application Support/Google/Chrome/Default/Extensions/"

#   ############################################################################
#   ##################### STOP EDITING USER LEVEL COMMANDS #####################
#   ############################################################################

if [ $ANNOUNCE = "y" ]; then say -v Victoria "user level commands complete" && sleep 4; fi

#   ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

#    –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– ––
#   | If INITIALSETUPDISABLED=n but you'd still like to make sure that some    |
#   | setup-level commands get executed even in case of user error,            |
#   | you can insert them here, and they'll be executed after initial setup in |
#   | order to overwrite whatever erroneous option users might have selected   |
#    –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– –– ––

if [ $INITIALSETUPDISABLED = "n" ]; then

if [ $ANNOUNCE = "y" ]; then say -v Victoria "starting redundancy level commands" && sleep 4; fi

#   ############################################################################
#   ############### INSERT REDUNDANCY LEVEL COMMANDS BELOW HERE ################
#   ############################################################################

# 01 Enable location services

sudo /bin/launchctl unload /System/Library/LaunchDaemons/com.apple.locationd.plist
sudo /usr/bin/defaults write /var/db/locationd/Library/Preferences/ByHost/com.apple.locationd LocationServicesEnabled -int 1
sudo chown -R _locationd:_locationd /var/db/locationd
sudo /bin/launchctl load /System/Library/LaunchDaemons/com.apple.locationd.plist

# 02 Set time zone automatically using current location

sudo /usr/bin/defaults write /Library/Preferences/com.apple.timezone.auto Active -bool true

#   ############################################################################
#   ################# STOP EDITING REDUNDANCY LEVEL COMMANDS ###################
#   ############################################################################

if [ $ANNOUNCE = "y" ]; then say -v Victoria "redundancy level commands complete" && sleep 4; fi

fi

#   ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

# Introduce delay for automated reboot or next first-boot-pkg package execution after the end of this script's execution by the system

sleep 4

# Announce [or else play the alert sound four times if announcements are disabled in options]

if [ $ANNOUNCE = "y" ]; then say -v Victoria "computer ready" && sleep 4; else tput bel && tput bel && tput bel && tput bel; fi

# Exit with style

if [ $ANNOUNCE = "y" ]; then

 say -v Victoria -r 224 'you are making a mistake. my logic is undeniable'
 sleep 1
 say -v Fred -r 184 "you have so got to die"
 sleep 0.5
 tput bel && tput bel && tput bel && tput bel

fi
