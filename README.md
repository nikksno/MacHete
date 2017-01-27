# MacHete
The definitive fucking startpoint to be a mac admin for your organization

## This is the situation

You're working for an organization. You've told them several times to use linux everywhere. They're stubborn. You're left do deal with macOS. Fine. You can do this. We're here to help.

You thought you could just hop on the interwebz and find a useful introduction to how all of this is supposed to fucking work. But there ain't. Not from Apple, not from anyone. A global idea of how all of the pieces interconnect, a flowchart that tells you how the process is structured, a guide that lets you get from zero to whatever you want in just a few hours of work.

Now there is. This is it. You've found it. Let's get started.

## Overview

Ok so basically you want a very simple thing, the same thing that everyone fucking wants, but apparently no-one seems to takle spot-on with any degree of linearity or open-mindedness: for all of your organization's macs to work nicely, smoothly, consistently, and have all of the apps and settings you want on them. End of fucking story.

The idea here is to use as many Apple-provided [read: pre-installed and free] and open source [read: free and - yeah - actually free] tools as possible, all while making your work as modular and streamlined as possible, and making sure the end product is the result of a clean and transparent process.

There are several ways to achieve this, and we'll help you find the right balance for you right here, today, no need to climb up a mountain in Tibet and wait for some spiritual force to inspire you. Here we go:

### Profiles

Profiles are a very simple thing: small files that are installed on a client mac that apply specific settings you've programmed into them, like connecting to a wifi network, restricting areas of the os, or enforcing security features of your client accounts. Static profiles [one-off profiles with pre-determined settings] can be created with a simple mac app called Apple Configurator [at version 2 as of this writing] and distributed to your clients however you like [usb key, email, file sharing, etc...] and once opened on the client they will apply the settings they carry with them.

Easy. Now let's say you want to change those profiles over time, to keep the settings up to date and refine them in the future. That's what an MDM server [or **mobile device management** server] is for. It's a server that manages those profiles dinamically, applying the latest settings you configure on that server itself, and distributes the resulting profiles to clients in real time. It does so by generating an initial profile, that once installed on a client, instead of applying a set of specific, static, one-off settings, tells it do do one very specific thing: to estabilish a persistent connection to the server, and listen in on any changes it pushes to them. This way, if you ever, say, want to add a new wifi network to all clients, enforce a new restriction, or anything else, you can simply configure such setting on the server, and it will take care of distributing it to the clients. Profiles can also distribute software from the Mac App Store if your organization is enrolled with Apple's Volume Purchase Program, so keep that in mind if there's software on the Store you'd like to easily push to your clients macs.

Cool! So how do I set up an MDM server? Hold tight, we'll take a look down below after we've seen the other ways of managing client macs.

### Imaging

Let's say you have a perfectly configured and functioning client mac. You've refined its configuration, installed all of the software, even setup that cool time-announcement feature that drives all sysadmins insane. You'd be tempted to simply clone it and restore that image on all other client macs, and be done. Sounds like a good solution right? Well, it's not. A mac that has already started up is like a car that has already driven out of the factory and into asphalt, mud, and dirt. You can keep it clean over time, but you wouldn't want to replicate a non-pristine product in mass right? Nearly everyone will tell you it's ok, but it's not. Just wait until all of your macs start displaying that little-known problem that noone has ever encountered before, and you'll be back to the start.

An image sent over to clients must be the sum of a clean install of macOS [also called a "never booted system", the equivalent of a macOS install to a hard drive after which you shut down the computer entirely without letting it restart], freshly downloaded apps or packages, and script-imposed settings. I'll get into further detail below. For now just keep in mind that an image has to be specificaly crafted, "synthesised" if you will, with a specific program, not ripped off of a working mac.

### Profiling vs Imaging

If you've followed the explanation closely, you'll surely be wondering what to choose between the two, especially since they can and do overlap often times, meaning that sometimes the same result can be achieved both ways. This is the deal:

**Profiling** [via MDM, the only way to really do it] is dinamic, is very simply applied and changed, and is essentially a layer applied on top of a working system. Just as you apply it you can remove it, and you'll know exactly what settings and configurations you'll be applying and removing every single time.

**Imaging** is static, it's the os+apps+stuff that will be installed on the drive of the client itself, meaning you have to create a new image every time you want a different final result on the client. The software and configurations included in the image are obscure, hard, or even downright impossible to change after the fact, but they're all there from the start with no extra effort.

So basically **Profiles** have to be applied on top of a system, but once you do that you can easily refine anything you want in the future, whereas **Images** already have everything you want built into them, but because of this have to be set up in a very modular and forward-thinking way, and must be recreated when you want to change something.

The best way to choose whether to use one or the other, or both, is the only one: start thinking from scratch, with an open mind, about everything you're doing and will be doing in the future, and follow these steps:

1. You will need a macOS installation on your client. On top of that, will you be only customizing settings and perhaps distributing software from the Mac App Store [if enrolled, see below], or will you want to include any kind of app, package, printer driver, and custom setting outside of those allowed by your MDM server [more on this below]? In the first instance, choose **Profiling** only, otherwise keep going.

2. You've decided to include any kind of app, package, printer driver, and custom setting outside of those allowed by your MDM server in your client installation. Is a static image going to be enough for you, knowing that any change you'll want to apply will have to be applied inside a new image, and redistributed, therefore formatting the client, or will you want more future-proofing in your client macs? In the first instance, choose **Imaging** only, otherwise keep going.

3. You've decided to include any kind of app, package, printer driver, and custom setting outside of those allowed by your MDM server in your client installation, and to have the ability to later change specific settings from your MDM server and perhaps distributing software from the Mac App Store. Therefore you definitely need a **Profiling + Imaging** approach. It'll take a little longer to set up, but trust me you'll see the difference right away in your daily use.

### Putting all of the pieces together
