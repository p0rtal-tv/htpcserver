#!/bin/bash

apt-get update
apt-get upgrade -y
apt-get dist-upgrade -y
apt-get install nano git

######
##Add Repos & Keys
######
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FDA5DFFC
echo "deb http://apt.sonarr.tv/ master main" | sudo tee -a /etc/apt/sources.list

########
###Insall Dependencies
#########
apt-get update 
aptitude install -y software-properties-common mono-devel unzip zip libmono-cil-dev

########
###Install Apps####
########

##Plex
cd /tmp/htpcserver/
sudo sh plex.sh

####
##Edit Plex User pw
####
passwd plex
usermod -aG sudo plex


##Trakt.tv Plugin
wget https://github.com/trakt/Plex-Trakt-Scrobbler/archive/master.zip -O Plex-Trakt-Scrobbler.zip
unzip Plex-Trakt-Scrobbler.zip && rm -f Plex-Trakt-Scrobbler.zip
systemctl stop plexmediaserver
cp -r Plex-Trakt-Scrobbler-*/Trakttv.bundle "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Plug-ins/"
systemctl start plexmediaserver

##PlexRequests
wget https://github.com/tidusjar/Ombi/releases/download/v2.2.1/Ombi.zip
unzip Ombi.zip && rm -f Ombi.zip
mkdir -p /opt/Ombi
mv Release/* /opt/Ombi

##Sonarr
apt-get install nzbdrone

##Radar
cd /opt
wget https://github.com/Radarr/Radarr/releases/download/v0.2.0.596/Radarr.develop.0.2.0.596.linux.tar.gz
tar -xvzf Radarr.develop.*.linux.tar.gz && rm -f Radarr.develop.*.linux.tar.gz

##nzbget
wget -O - http://nzbget.net/info/nzbget-version-linux.json | sed -n "s/^.*stable-download.*: \"\(.*\)\".*/\1/p" | wget --no-check-certificate -i - -O nzbget-latest-bin-linux.run
sh nzbget-latest-bin-linux.run
rm -f nzbget-latest-bin-linux.run

##Plexpy
git clone https://github.com/JonnyWong16/plexpy.git

########
####Systemd Files
########
cp /tmp/htpcserver/systemd/* /etc/systemd/system/
sudo systemctl enable sonarr
sudo systemctl enable radarr
sudo systemctl enable nzbget
sudo systemctl enable plexpy
sudo systemctl enable ombi 
sudo systemctl start sonarr
sudo systemctl start radarr
sudo systemctl start nzbget
sudo systemctl start plexpy
sudo systemctl start ombi

