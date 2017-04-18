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
apt-get install git sudo software-properties-common ufw mono-devel unzip zip libmono-cil-dev curl mediainfo nginx php5-fpm php5-mysql php5.0-sqlite
##Plex
##bash -c "$(wget -qO - https://raw.githubusercontent.com/mrworf/plexupdate/master/extras/installer.sh)"

##PlexRequests
cd /tmp
wget https://github.com/tidusjar/Ombi/releases/download/v2.2.1/Ombi.zip
unzip Ombi.zip && rm -f Ombi.zip
mkdir -p /opt/Ombi
mv /Ombi/Release/* /opt/Ombi

##Sonarr
apt-get install nzbdrone

##Radar
cd /opt
wget https://github.com/Radarr/Radarr/releases/download/v0.2.0.596/Radarr.develop.0.2.0.596.linux.tar.gz
tar -xvzf Radarr.develop.*.linux.tar.gz && rm -f Radarr.develop.*.linux.tar.gz

## Headphones
git clone https://github.com/rembo10/headphones.git

##nzbget
cd /opt
wget -O - http://nzbget.net/info/nzbget-version-linux.json | sed -n "s/^.*stable-download.*: \"\(.*\)\".*/\1/p" | wget --no-check-certificate -i - -O nzbget-latest-bin-linux.run
sh nzbget-latest-bin-linux.run
rm -f nzbget-latest-bin-linux.run

##Plexpy
git clone https://github.com/JonnyWong16/plexpy.git

##Organizr
cd /var/www
sudo git clone https://github.com/causefx/Organizr
chown -R www-data:www-data /var/www/Organizr

##Nginx
unlink /etc/nginx/sites-enabled/default
cp /tmp/htpcserver/reverseproxy /etc/nginx/sites-available/reverseproxy
ln -s /etc/nginx/sites-available/reverseproxy /etc/nginx/sites-enabled/reverseproxy

##Systemd Files
cp /tmp/htpcserver/systemd/* /etc/systemd/system/

