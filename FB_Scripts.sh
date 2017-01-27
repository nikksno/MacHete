#!/bin/bash

# MacHete First Boot scripts

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

# 05 Enable battery percentage display in menu battery

currentUser=`ls -l /dev/console | cut -d " " -f4`
sudo -u $currentUser defaults write com.apple.menuextra.battery ShowPercent YES
sudo -u $currentUser killall SystemUIServer

# 06 Enable NoSleep at 15:42 every day [if the mac is awake at that time to actually execute this cronjob - this is intentional] and keep awake for scheduled updates from the ARD server until 20:32 [scheduled shutdown time] + 10 minutes [scheduled shutdown pre-alert time], after which disable NoSleep at 20:56 in case of missed scheduled shutdown. Also disable NoSleep after reboot.

sudo touch /var/at/tabs/root
echo "echo '42 15 * * * /usr/local/bin/NoSleepCtrl -abs 1,1 && sleep 4 && /usr/local/bin/NoSleepCtrl -abs 1,1 && sleep 4 && /usr/local/bin/NoSleepCtrl -abs 1,1 && caffeinate -t 18840 && /usr/local/bin/NoSleepCtrl -abs 0,0' > /var/at/tabs/root" | sudo bash
echo "echo '@reboot sleep 108 && /usr/local/bin/NoSleepCtrl -abs 0,0' >> /var/at/tabs/root" | sudo bash
sudo crontab /var/at/tabs/root

# 07 Disable Adobe Flash player updater

sudo touch /Library/Application\ Support/Macromedia/mms.cfg
echo "echo 'AutoUpdateDisable=1' > /Library/Application\ Support/Macromedia/mms.cfg" | sudo bash
echo "echo 'SilentAutoUpdateEnable=0' >> /Library/Application\ Support/Macromedia/mms.cfg" | sudo bash

# 08 Install one-sided printers [drivers and driver substitutions in image]

# Here we replace the drivers in question with their substitutes and then actually install the printers
# To install two-sided printers [driver default] disable driver substitutions on the next two lines by commenting them out

sudo mv /Library/Printers/PPDs/Contents/Resources/KONICAMINOLTA454e-1sided.gz /Library/Printers/PPDs/Contents/Resources/KONICAMINOLTA454e.gz
sudo mv /Library/Printers/PPDs/Contents/Resources/KONICAMINOLTAC364e-1sided.gz /Library/Printers/PPDs/Contents/Resources/KONICAMINOLTAC364e.gz

sudo lpadmin -p StaffRoom_Printer_Left_v2 -D "StaffRoom Printer Left v2" -L "Staff Room" -E -v lpd://10.129.88.116 -P /Library/Printers/PPDs/Contents/Resources/KONICAMINOLTA454e.gz
sudo lpadmin -p StaffRoom_Printer_Right_v2 -D "StaffRoom Printer Right v2" -L "Staff Room" -E -v lpd://10.129.88.115 -P /Library/Printers/PPDs/Contents/Resources/KONICAMINOLTA454e.gz
sudo lpadmin -p GroundFloor_Printer_Colour_v2 -D "GroundFloor Printer Colour v2" -L "Ground Floor" -E -v lpd://10.129.88.111 -P /Library/Printers/PPDs/Contents/Resources/KONICAMINOLTAC364e.gz

# Announce commands completed

say -v Victoria "commands complete"

# Wait for Initial Setup to be completed by the user

while [ ! -f /var/db/.AppleSetupDone ]
do
sleep 16
done

# Announce setup complete

say -v Victoria "setup complete"

# Introduce delay for automated reboot after the end of this script's execution by the system

sleep 42

# Announce computer ready

say -v Victoria "computer ready"

# Exit script

exit
