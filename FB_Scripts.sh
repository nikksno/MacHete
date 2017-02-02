#!/bin/bash

# MacHete First Boot scripts

# Introduce delay to avoid audio conflict with Voiceover announcement

sleep 16

# Announce

say -v Victoria "starting firstboot script"

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

sudo lpadmin -p StaffRoom_Printer_Left_v2 -D "StaffRoom Printer Left v2" -L "Staff Room" -E -v lpd://192.168.1.101 -P /Library/Printers/PPDs/Contents/Resources/KONICAMINOLTA454e.gz
sudo lpadmin -p StaffRoom_Printer_Right_v2 -D "StaffRoom Printer Right v2" -L "Staff Room" -E -v lpd://192.168.1.102 -P /Library/Printers/PPDs/Contents/Resources/KONICAMINOLTA454e.gz
sudo lpadmin -p GroundFloor_Printer_Colour_v2 -D "GroundFloor Printer Colour v2" -L "Ground Floor" -E -v lpd://192.168.1.103 -P /Library/Printers/PPDs/Contents/Resources/KONICAMINOLTAC364e.gz

# Announce

say -v Victoria "system level commands complete"

# Wait for Initial Setup to be completed by the user

while [ ! -f /var/db/.AppleSetupDone ]
do
sleep 1
done

# Announce

say -v Victoria "setup complete"

# Introduce delay before user-specific actions are performed

sleep 32

# Perform user-specific actions since user [users in case of DEP/ASM admin user creation policy] has/have now been created

# Announce

say -v Victoria "starting user level commands"

# 01 Enable battery percentage display in menu battery

sudo -u admin defaults write com.apple.menuextra.battery ShowPercent YES
sudo -u user defaults write com.apple.menuextra.battery ShowPercent YES
sudo killall SystemUIServer

# Announce user commands complete

say -v Victoria "user level commands complete"

# Introduce delay for automated reboot after the end of this script's execution by the system

sleep 32

# Announce computer ready

say -v Victoria "computer ready"

# Exit script

exit
