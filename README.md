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

Easy. Now let's say you want to change those profiles over time, to keep the settings up to date and refine them in the future. That's what an MDM server [or **mobile device management** server] is for. It's a server that manages those profiles dinamically, applying the latest settings you configure on that server itself, and distributes the resulting profiles to clients in real time. It does so by generating an initial profile, that once installed on a client, instead of applying a set of specific, static, one-off settings, tells it do do one very specific thing: to estabilish a persistent connection to the server, and listen in on any changes it pushes to them. This way, if you ever, say, want to add a new wifi network to all clients, enforce a new restriction, or anything else, you can simply configure such setting on the server, and it will take care of distributing it to the clients.

Cool! So how do I set up an MDM server? Hold tight, we'll take a look down below after we've seen the other ways of managing client macs.

