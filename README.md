# MacHete
The definitive fucking startpoint to be a mac admin for your organization. Includes a complete overview of how everything works, links to the tools you'll be using, and a functional directory structure with sample files to prepare your final products. That's right: this is going from start to end.

## This is the situation

You're working for an organization. You've told them several times to use linux everywhere. They're stubborn. You're left do deal with macOS. Fine. You can do this. We're here to help.

You thought you could just hop on the interwebz and find a useful introduction to how all of this is supposed to fucking work. But there ain't. Not from Apple, not from anyone. A global idea of how all of the pieces interconnect, a flowchart that tells you how the process is structured, a guide that lets you get from zero to whatever you want in just a few hours of work.

Now there is. This is it. You've found it. Let's get started.

## Overview

Ok so basically you want a very simple thing, the same thing that everyone fucking wants, but apparently no-one seems to takle spot-on with any degree of linearity or open-mindedness: for all of your organization's macs to work nicely, smoothly, consistently, and have all of the apps and settings you want on them. End of fucking story.

The idea here is to use as many Apple-provided [read: pre-installed and free] and open source [read: free and - yeah - actually free] tools as possible, all while making your work as modular and streamlined as possible, and making sure the end product is the result of a clean and transparent process that you can easily maintain over time and - why not - even keep using smoothly in the future without having to re-do all your work from the fucking beginning.

There are several ways to achieve this, and we'll help you find the right balance for you right here, today, no need to climb up a mountain in Tibet and wait for some spiritual force to inspire you. Here we go:

## Profiles

Profiles are a very simple thing: small files that are installed on a client mac that apply specific settings you've programmed into them, like connecting to a wifi network, restricting areas of the os, or enforcing security features of your client accounts. Static profiles [one-off profiles with pre-determined settings] can be created with a simple mac app called Apple Configurator [at version 2 as of this writing] and distributed to your clients however you like [usb key, email, file sharing, etc...] and once opened on the client they will apply the settings they carry with them.

Easy. Now let's say you want to change those profiles over time, to keep the settings up to date and refine them in the future. That's what an MDM server [or **mobile device management** server] is for. It's a server that manages those profiles dinamically, applying the latest settings you configure on that server itself, and distributes the resulting profiles to clients in real time. It does so by generating an initial profile, that once installed on a client, instead of applying a set of specific, static, one-off settings, tells it do do one very specific thing: to estabilish a persistent connection to the server, and listen in on any changes it pushes to them. This way, if you ever, say, want to add a new wifi network to all clients, enforce a new restriction, or anything else, you can simply configure such setting on the server, and it will take care of distributing it to the clients. Profiles can also distribute software from the Mac App Store if your organization is enrolled with Apple's Volume Purchase Program, so keep that in mind if there's software on the Store you'd like to easily push to your clients macs.

Cool! So how do I set up an MDM server? Hold tight, we'll take a look down below after we've seen the other ways of managing client macs.

## Imaging

Let's say you have a perfectly configured and functioning client mac. You've refined its configuration, installed all of the software, even setup that cool time-announcement feature that drives all sysadmins insane. You'd be tempted to simply clone it and restore that image on all other client macs, and be done. Sounds like a good solution right? Well, it's not. A mac that has already started up is like a car that has already driven out of the factory and into asphalt, mud, and dirt. You can keep it clean over time, but you wouldn't want to replicate a non-pristine product in mass right? Nearly everyone will tell you it's ok, but it's not. Just wait until all of your macs start displaying that little-known problem that noone has ever encountered before, and you'll be back to the start.

An image sent over to clients must be the sum of a clean install of macOS [also called a "never booted system", the equivalent of a macOS install to a hard drive after which you shut down the computer entirely without letting it restart], freshly downloaded apps or packages, and script-imposed settings. I'll get into further detail below. For now just keep in mind that an image has to be specificaly crafted, "synthesised" if you will, with a specific program, not ripped off of a working mac.

## Profiling vs Imaging

If you've followed the explanation closely, you'll surely be wondering what to choose between the two, especially since they can and do overlap often times, meaning that sometimes the same result can be achieved both ways. This is the deal:

**Profiling** [via MDM, the only way to really do it] is dinamic, is very simply applied and changed, and is essentially a layer applied on top of a working system. Just as you apply it you can remove it, and you'll know exactly what settings and configurations you'll be applying and removing every single time.

**Imaging** is static, it's the os+apps+stuff that will be installed on the drive of the client itself, meaning you have to create a new image every time you want a different final result on the client. The software and configurations included in the image are obscure, hard, or even downright impossible to change after the fact, but they're all there from the start with no extra effort.

So basically **Profiles** have to be applied on top of a system, but once you do that you can easily refine anything you want in the future, whereas **Images** already have everything you want built into them, but because of this have to be set up in a very modular and forward-thinking way, and must be recreated when you want to change something.

The best way to choose whether to use one or the other, or both, is the only one: start thinking from scratch, with an open mind, about everything you're doing and will be doing in the future, and follow these steps:

1. You will need a macOS installation on your client. On top of that, will you be only customizing settings and perhaps distributing software from the Mac App Store [if enrolled, see below], or will you want to include any kind of app, package, printer driver, and custom setting outside of those allowed by your MDM server [more on this below]? In the first instance, choose **Profiling** only, otherwise keep going.

2. You've decided to include any kind of app, package, printer driver, and custom setting outside of those allowed by your MDM server in your client installation. Is a static image going to be enough for you, knowing that any change you'll want to apply will have to be applied inside a new image, and redistributed, therefore formatting the client, or will you want more future-proofing in your client macs? In the first instance, choose **Imaging** only, otherwise keep going.

3. You've decided to include any kind of app, package, printer driver, and custom setting outside of those allowed by your MDM server in your client installation, and to have the ability to later change specific settings from your MDM server and perhaps distributing software from the Mac App Store. Therefore you definitely need a **Imaging + Profiling** approach. It'll take a little longer to set up, but trust me you'll see the difference right away in your daily use.

## Putting all of the pieces together

### Profiling only

You've chosen to go lightweight. You're ready to zip through this like a superhero flying through the night sky. You know what it involves. Here is what you're going to do on the server:

1. Set up the MDM server
2. Save the enrollment profiles on the external drive

And on each client:

1. Install virgin macOS via external drive
2. Perform the initial setup [language, region, user, etc...]
3. Install the profiles manually
4. Go back behind the scenes in your server room bunker and manage every aspect of reality from your workstation like a boss.

You can make the process even simpler by creating a **NetInstall** image [**nothing to do with the "images" we've been talking about in this document**, it's just an image of a virgin macOS installation], and automate the process by simply connecting the client to an ethernet cable, restarting it while pressing the N button, and letting it do its thing [you can do it via wifi as well, although its reliability heavily depends on your infrastructure of course]. You can even add the MDM profiles directly inside this "image", so that the steps on each client come down to:

Server side:

1. Set up the MDM server
2. Download the macOS installer
3. Create the NetInstall "image" with macOS + the enrollment profiles

Client side:

1. Start up the client while pressing N [via ethernet or wifi] [profiles are automatically installed alongside macOS]
2. Perform the initial setup [language, region, user, etc...]
3. Move on with the rest of your day.

This requires building the netinstall "image", but it's very simple to do, and only has to be done once per major macOS release [minor updates are performed by the clients anyway]. We'll see how to do this down below.

### Imaging only

You've chosen the slightly more involved approach. You're going to try and set it and forget it, and see how it works out. Let's see what we'll have to do on the server:

1. Collect all of the apps and packages you want to include in the image, and customize the settings you'll apply with the script.
2. Download the macOS installer
3. Create the image with macOS+software+settings inside
4. Convert the image to a NetRestore image
5. Set up the NetRestore service on the server

And on the client:

1. Start up the client while pressing N [via ethernet or wifi]
2. Perform the initial setup [language, region, user, etc...]
3. Rock like a badass

### Imaging + Profiling

You've chosen the full bundle. You're committed to saving the day once and for all for yourself and your future colleagues. You're going to go in, do your stuff, and walk out the other side like a hero. Let's get right to it:

Server side:

1. Set up the MDM server
2. Collect all of the apps and packages you want to include in the image, and customize the extra [not-in-MDM] settings you'll apply with the script.
3. Download the macOS installer
4. Create the image with macOS+software+settings+profiles inside
5. Convert the image to a NetRestore image
6. Set up the NetRestore service on the server

Client side:

1. Start up the client while pressing N [via ethernet or wifi]
2. Perform the initial setup [language, region, user, etc...]
3. Retire. You've done your job.

## Getting ready

Whatever you'll be doing I highly recommend using the following setup and software:

1. A Mac workstation, which is a normal mac [not the server] possibly freshly installed and with no customizations.
2. An external drive. This will allow you to easily have everything you need on any other workstations you might work on. Apple tools fail often and keep failing afterwards. You'll likely have to rotate workstation or format it sooner or later. Trust me.
3. A backup utility to make a clone [a 1 to 1 exact copy] of your external drive, either to another external drive or to some remote storage. I highly recommend [Carbon Copy Cloner](http://bombich.com) [not free - 30 day trial], but if you don't want to spend the cash you can achieve the same result from the command line using the rsync tool, losing the benefits of the gui [obviously ;], easy scheduling, and other stuff.

If you'll be going with an Imaging or Imaging + Profiling approach you'll also need:

4. The superb [AutoDMG](https://github.com/MagerValp/AutoDMG/releases). Download the dmg for the latest release from the linked page. Copy the app from inside the disk image to the root of the Macs folder on your external drive.
5. The amazing [first-boot-pkg](https://github.com/grahamgilbert/first-boot-pkg). Press Clone or Download > Download ZIP, open the zip, and copy all contents to the 02 > 02 > 03 folder [except for the readme.md file].
6. The epic [create-user-pkg](https://github.com/MagerValp/CreateUserPkg). Download the dmg for the latest release from the linked page. Copy the app from inside the disk image to the root of the Macs folder on your external drive.
7. The unreal [Iceberg](http://s.sudre.free.fr/Software/Iceberg.html). Download it and copy the mpkg from inside the disk image to the root of the Macs folder on your external drive. Also open said mpkg and install it to your workstation. You'll have to actually reinstall Iceberg if you change workstation, as it's not a self-contained app, and cannot therefore be executed as is from the external drive.

If you'll be creating your own software packages for the reasons listed above you'll also need:

1. [Composer](https://www.jamf.com/products/jamf-composer/), which basically takes a snapshot of a workstation's system before and after an event, and bundles all the differences between the two snapshots [the delta] in an installable package. You can use it to package deltas that include any kind of activity that is written to disk by the system [software installations, licence registrations, preference modifications, etc...]. Free alternatives never worked in my experience as they were largely outdated or buggy.

## How to actually fucking do this

### Note about Imaging + Profiling

To achieve this follow the Profiling only guide and the actual Imaging + Profiling guide down below.

### Profiling only

[developing]

### Imaging only

To achieve this follow the Imaging + Profiling guide *without* the additional steps written in *italics*.

### Imaging + Profiling [skip steps in *italics* for Imaging only]

#### Overview

AutoDMG installs pure macOS on a disk image with optional additional software. This can be either:

1. A self-contained app [aka "drag and drop" app. i.e.: Google Chrome]. Once added to AutoDMG it will copy them inside the /Applications folder on the system installed inside the DMG
2. A pre-compiled package [i.e.: printer drivers, Adobe CS, and any software that must be installed from a package]. Once added to AutoDMG it will execute the installation of this software on the system installed inside the DMG with these limitations.
3. A package composed by us using Iceberg or Composer [i.e.: Lego Wedo, ActivDriver + ActivInspire, etc...] as the respective software isn't installable with a standard procedure or to include license keys and other stuff. Once added to AutoDMG it will execute the installation of this software on the system installed inside the DMG with these limitations.

#### Software types

All three types are simply dragged and dropped into AutoDMG during the DMG creation process and it will handle them as written above depending on their type. The limitations we are talking about usually involve scripts containing commands like lpadmin that won't apply to the system in the DMG but the one of the host using AutoDMG. Pre-made packages usually work. Custom-made packages [Iceberg, Composer] must not include scripts. If software installed via a pre-made package ends up not working as expected on clients and/or custom-made packages must include scripts, consider adding them to the first-boot-package. If you only need to perform commands without actually dealing with files and folders [such as sputil to disable gatekeeper] simply add such commands to the first boot script that will get bundled inside the first-boot-package.

#### Workflow setup

1. Format your external drive [GUID partition table, one partition in APFS or "Mac OS Extended (Journaled)" called MacHete]

2. Download the zip of this repo from the top right of the webpage and unzip it

3. Place all subfolders inside the MacHete folder [00 - Tools, 01, 02, and so on] in the MacHete Volume you just created in step 1.

4. Download the required tools from their respective websites [see above in this README] and place them in the "00 - Tools" folder replacing the placeholder subfolders

5. Download "Install macOS" from the App Store. Click continute when prompted. When the  download is finished move the installer to the "01 - macOS Installers" folder.

6.1. Drag self-contained apps and pre-composed packages in the "02 - Software" > "02 - Finals" subfolder.

6.2. If there's a package you're going to compose yourself with Iceberg or Composer create a directory with its name inside "02 - Software" > "01 - Sources". Work with your preferred software [Composer for instance] to package everything and place the final product in "02 - Software" > "02 - Finals".

[not writing the full name of folders from here on, only the leading numbers, i.e. "03 - Firstboot" becomes "03"]

7.1.1. Open Apple Configurator 2 and create a WiFi profile from File > New Profile. The only payload will be "network": configure the WiFi network for clients, and save the profile to the **03 > 01 > 01 > 01** folder.

7.1.2. In the **03 > 01 > 01 > 03**  folder open the Iceberg project [in this case "WiFi_Installer.packproj"] and choose "Build" from the Build menu [command-B]. Drag the created pkg file from the "build" subfolder inside **03 > 01 > 01 > 03** folder to the **03 > 02** folder.

7.2. Open the create-user-pkg utility you previously downloaded, generate user-creating packages for the users you'll want to create on your client macs, and place the final pkg files inside the **03 > 01 > 02** folder and inside the **03 > 02** folder.

7.3.1. Open the "MacHete_FirstBoot.sh" script inside the **03 > 01 > 03 > 01** folder. These commands will run on the booted volume so you can write any valid command you'd like. Follow the comments to understand what everything does and what to write where.

7.3.2. Open the Iceberg project inside the **03 > 01 > 03 > 02** folder, build, and copy the produced pkg file from the "build" subfolder to the **03 > 02** folder.

7.4.1. In the **03 > 01 > 04 > 01** folder drag the trust profile and enrollment profile from your mdm server [profile manager for instance].

7.4.2. Edit the names in the script in **03 > 01 > 04 > 02** to match the names of such profiles.

7.4.3. Open the Iceberg project inside the **03 > 01 > 04 > 03** folder, build, and copy the produced pkg file from the "build" subfolder to the **03 > 02** folder.

7.5.1. In the **03 > 01 > 99** you'll find the SecondBoot package creation sources. You can edit the script inside the **03 > 01 > 99 > 01 > 01 > 01** folder just like you did for the FirstBoot script, and then build its own Iceberg project. The directory structure and the entire logic are the exact same as for the FirstBoot Script you created in step 7.3.

7.5.2. Copy the produced pkg from the **03 > 01 > 99 > 01 > 01 > 02 > build** subfolder to the **03 > 01 > 99 > 02** folder.

7.5.3. Open a terminal window, type sudo, and drag the first-boot-pkg program found inside the **"00 - Tools"** folder into the terminal window: this will insert the path to the first-boot-pkg program inside the window, preceded by the "sudo" word you typed. Now type "--pkg" followed by a space and drag in the package from the **03 > 01 > 99 > 02** folder.

7.5.4. Now press return and enter your admin password [if you get errors, ensure you're doing this from an admin account on your workstation]. Your first boot package will be written to your home directory [~/]. Copy it and paste it into the **03 > 01 > 99 > 03** folder and into the **03 > 02** folder.

7.6 Now in the **03 > 02** folder you should have all of the needed packages. Open a terminal window, type sudo, and drag the first-boot-pkg program found inside the **"00 - Tools"** folder into the terminal window: this will insert the path to the first-boot-pkg program inside the window, preceded by the "sudo" word you typed. Now type "--pkg" followed by a space and drag in the first package from the **03 > 02** folder." and drag in the first package inside 02 > 02 > 02, then type "--pkg" and drag in the second package inside 02 > 02 > 02, and so on. You should have something like:

```
**sudo** /Volumes/MacHete/00 - Tools/first-boot-pkg **--pkg** "/Volumes/MacHete/03 - Firstboot/02 - Packages/WiFi_Installer.pkg" **--pkg** "/Volumes/MacHete/03 - Firstboot/02 - Packages/User_Creator.pkg" **--pkg** "/Volumes/MacHete/03 - Firstboot/02 - Packages/MacHete_FirstBoot.pkg" **--pkg** "/Volumes/MacHete/03 - Firstboot/02 - Packages/ProMan_Enroller.pkg" **--pkg** "/Volumes/MacHete/03 - Firstboot/02 - Packages/second-boot.pkg"
```

Now press return and enter your admin password [if you get errors, ensure you're doing this from an admin account on your workstation]. Your first boot package will be written to your home directory [~/]. Copy it and paste it into the **03 > 03** folder.

#### AutoDMG

To optimize the functionality of AutoDMG use the following workflow as suggested by the developer:

1. Drag the macOS installer from the **01** folder into AutoDMG. Do not apply updates. Do not add any software. Build it and save it to the **04** folder. This will create a dmg called osx-\*\*\*

2. Drag the newly created DMG in AutoDMG from the **04** folder. Download updates and apply them. Do not add any software. Build it and save it back into the **04** folder. This will create a dmg called osx-updated-\*\*\*

3.1. Drag the newly created DMG in AutoDMG from the **04** folder. Do not apply any update.

3.2. Add all of your Apps, pre-made packages, and custom-packages from the **03 > 02** folder into the lower box in AutoDMG.

3.3. Add the first-boot.pkg package from the **03 > 03** folder into AutoDMG **below** all apps and packages added in the previous step.

3.4. Build it and save it to the **04** folder. This will create a dmg called osx-custom-*\*\*.

This will be the final DMG to be fed to System Image Utility to create the NBI. Once AutoDMG is finished open the DMG in finder, skip verification, and then launch SIU.

#### System Image Utility

Select NetRestore, select the Macintosh HD volume from Finder [the content of the opened DMG], and click next on every step, only modifying the following:
Automatically install to: enable it and write "Macintosh HD" exactly without quotes. Check erase before install.
Call it NETR XXxx YYyy PFRX where XXXX is the version of macOS in the format:
XX for major macOS version [10 for sierra]
xx for minor macOS version [12 for sierra]
YY for major image version [sequential, up to you, currently 12 (for v1.2)]
yy for minor image version [sequential, up to you, currently 04 (for v1.2)]
PFRX stands for Partition [later added in Automator], Format, Restore, X [other stuff]
At the MAC Address screen, press customize on the bottom left. This will open Automator with all fields pre-populated.
Automator

Once in Automator:

Check the first step of the workflow has Macintosh HD with a white icon selected, since this setting tends to get lost when opening Automator from SIU
From the left sidebar look for the "partition disk" task and drag it in the workflow right underneath the "define netrestore source", so as the second element overall.
Select "partition the first disk found"
Input the name of the volume created as "Macintosh HD" exactly without quotes
Towards the end [further details developing...] enter "Macintosh HD" exactly without quotes if the field is not greyed out [if it is don't worry, it happens, this won't affect you in any way, in theory] and copy and paste the name between fields [further details developing...]
Select the correct destination for your final NBI if you'd rather it not ending up in the root of your user's home folder
Press build on the top right and wait the 15 - 45 minutes it takes it to build the NBI.

Once this image is complete, copy it to the server's desktop.

#### macOS Server setup

On the server, open the Server.app App. On the left sidebar, click advanced, and them among the entries that appear choose NetInstall. In storage locations, select edit, then set your server's main drive [or an external one if available] to images only. This will create the /Library/NetBoot/NetBootSP0/ directory structure to the chosen drive.
Back in the Finder, from the Go menu, select Go to Folder. Enter "/Library/NetBoot/NetBootSP0/" without quotes or "/Volumes/DRIVE_NAME/Library/NetBoot/NetBootSP0/" without quotes in case of a non-main drive if you've selected such in the previous step.
Copy the NBI from the desktop to the NetBootSP0 folder.
Back on Server.app, wait for the image to appear in the list, then select it, click the cog wheel, edit it, set make available over to NFS, press ok. Click the cog wheel once again, select use as default image. You're done.

#### Clients

Start up a mac with ethernet to the same lan / vlan as your server and possibly power if it's a notebook. As soon as you press the power button press and hold the N button on its keyboard until you see a flashing globe in the middle of the screen, then, if all works correctly, your mac should take at least around 30 - 45 minutes to restore depending on your wired lan's speed.
When it's finished, it'll reboot, and take you to the initial setup screen. All extras will have already been applied except for the firstboot script, which will start running shortly in the background, alerting you verbally on its status.
Follow the setup steps until the end. When finished the mac will reboot.
When finished open system preferences > sharing, change the mac's name, and enable remote management with all privileges [alt-click selects all checkboxes].
The mac is now ready to be given to the user or placed in its location.

#### developing [20170215 ~ ...]
