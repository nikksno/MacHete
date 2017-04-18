#!/bin/bash

sudo /usr/bin/profiles -I -F /Library/Scripts/A-Trust_Profile_for_evilcorp.mobileconfig

sleep 4

sudo /usr/bin/profiles -I -F /Library/Scripts/B-Mac_Enrollment_Profile.mobileconfig
