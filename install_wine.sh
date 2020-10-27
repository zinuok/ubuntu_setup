#!/bin/bash

## Install wine to Intel based Linux
## method from official one doesn't work (cause dependency problem)
## ref: https://nixytrix.com/error-winehq-stable-depends-wine-stable-5-0-0-bionic/

# Add 32-bit support:
sudo dpkg --add-architecture i386

# Download the WineHQ repository key:
wget -nc https://dl.winehq.org/wine-builds/winehq.key -O /tmp/winehq.key

# Install the WinHQ repository key:
sudo apt-key add /tmp/winehq.key

# Install the Wine Repository:
sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main'

# Download the key needed for the OBS faudio repository:
wget -nv https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/Release.key -O /tmp/Release.key

# Install the key:
sudo apt-key add - < /tmp/Release.key

# Add the OBS faudio repository:
sudo apt-add-repository 'deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/ ./'

# Update your repositories:
sudo apt-get update

# Install Wine:
sudo apt install --install-recommends winehq-stable
