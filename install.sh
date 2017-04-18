#!/bin/bash

apt-get update
apt-get upgrade -y
apt-get dist-upgrade -y

##Repos & Keys
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb http://download.mono-project.com/repo/debian wheezy main" | sudo tee /etc/apt/sources.list.d/mono-xamarin.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FDA5DFFC
echo "deb http://apt.sonarr.tv/ master main" | sudo tee /etc/apt/sources.list.d/sonarr.list




apt get update 
apt-get install git sudo software-properties-common ufw mono-complete unzip zip libmono-cil-dev curl mediainfo

##Plex
##bash -c "$(wget -qO - https://raw.githubusercontent.com/mrworf/plexupdate/master/extras/installer.sh)"

##PlexRequests
cd /tmp
wget https://github.com/tidusjar/Ombi/releases/download/v2.2.1/Ombi.zip
unzip Ombi.zip && rm -f Ombi.zip
mkdir -p /opt/Ombi
mv /Ombi/Release/* /opt/Ombi
cp /tmp/htpcserver/systemd/ombi.service /etc/systemd/system/ombi.service

##Sonarr
apt-get install nzbdrone
cp /tmp/htpcserver/systemd/sonarr.service /etc/systemd/system/sonarr.service

##Radar
cd /opt
wget https://github.com/Radarr/Radarr/releases/download/v0.2.0.596/Radarr.develop.0.2.0.596.linux.tar.gz
tar -xvzf Radarr.develop.*.linux.tar.gz && rm -f Radarr.develop.*.linux.tar.gz
cp /tmp/htpcserver/systemd/radarr.service /etc/systemd/system/radarr.service

##nzbget
cd /opt
wget -O - http://nzbget.net/info/nzbget-version-linux.json | sed -n "s/^.*stable-download.*: \"\(.*\)\".*/\1/p" | wget --no-check-certificate -i - -O nzbget-latest-bin-linux.run
sh nzbget-latest-bin-linux.run
rm -f nzbget-latest-bin-linux.run
cp /tmp/htpcserver/systemd/nzbget.service /etc/systemd/system/nzbget.service

##Plexpy
git clone https://github.com/JonnyWong16/plexpy.git

