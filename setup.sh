#!/bin/bash

echo "root:toor" | chpasswd

####
##Edit SSHD
####
sed -i 's/PermitRootLogin yes/PermitRootLogin without-password/g' /etc/ssh/sshd_config
sed -i 's/#\?\(PasswordAuthentication\s*\).*$/\1 no/' /etc/ssh/sshd_config
sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config
sed -i 's/Port 22/Port 33' /etc/ssh/sshd_config

######
##Add Repos & Keys
######
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FDA5DFFC
echo "deb http://download.mono-project.com/repo/debian wheezy main" | sudo tee -a /etc/apt/sources.list
echo "deb http://apt.sonarr.tv/ master main" | sudo tee -a /etc/apt/sources.list
echo "deb http://mirrors.digitalocean.com/debian jessie main contrib non-free" | sudo tee -a /etc/apt/sources.list
echo "deb-src http://mirrors.digitalocean.com/debian jessie main contrib non-free" | sudo tee -a /etc/apt/sources.list
echo "deb http://mirrors.digitalocean.com/debian jessie-updates main contrib non-free" | sudo tee -a /etc/apt/sources.list
echo "deb-src http://mirrors.digitalocean.com/debian jessie-updates main contrib non-free" | sudo tee -a /etc/apt/sources.list
echo "deb-src http://security.debian.org/ jessie/updates main contrib non-free" | sudo tee -a /etc/apt/sources.list

########
###Insall Dependencies
#########
apt-get update 
aptitude install -y software-properties-common expect mono-devel unzip zip libmono-cil-dev curl mediainfo nginx php php-fpm php-mysql php-sqlite sqlite3 fuse unionfs-fuse

#######
##Make Directories
#######
mkdir -p /down/{complete,incomplete,watch}
mkdir -p /plex/{movies,tv,kidstv,kidsmovies,music}

########
###Install Apps####
########

##Plex
cd /tmp/htpcserver/
sudo sh plex.sh

####
##Edit Plex User pw
####
echo "plex:toor" | chpasswd
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

##Headphones
git clone https://github.com/rembo10/headphones.git

##nzbget
wget -O - http://nzbget.net/info/nzbget-version-linux.json | sed -n "s/^.*stable-download.*: \"\(.*\)\".*/\1/p" | wget --no-check-certificate -i - -O nzbget-latest-bin-linux.run
sh nzbget-latest-bin-linux.run
rm -f nzbget-latest-bin-linux.run

##Plexpy
git clone https://github.com/JonnyWong16/plexpy.git

##Organizr
cd /var/www
sudo git clone https://github.com/causefx/Organizr
chown -R www-data:www-data /var/www/Organizr

####
##Permissions
chown -R plex:plex /opt
chown -R plex:plex /down
chown -R plex:plex /plex
chmod -R 755 /opt
chmod -R 755 /down
chmod -R 755 /plex

####
##Reverse Proxy && Iptables
####

##Nginx
unlink /etc/nginx/sites-enabled/default
cp /tmp/htpcserver/reverseproxy /etc/nginx/sites-available/reverseproxy
ln -s /etc/nginx/sites-available/reverseproxy /etc/nginx/sites-enabled/reverseproxy

##UFW
sudo ufw default deny incoming
sudo ufw allow "Nginx Full"
sudo ufw allow "ssh"
sudo ufw allow "OpenSSH"
sudo ufw allow "WWW Full"
sudo ufw allow 22
sudo ufw allow 33
sudo ufw enable

########
####Systemd Files
########
cp /tmp/htpcserver/systemd/* /etc/systemd/system/
sudo systemctl enable sonarr
sudo systemctl enable radarr
#sudo systemctl enable headphones
sudo systemctl enable nzbget
sudo systemctl enable plexpy
sudo systemctl enable ombi 
sudo systemctl start sonarr
sudo systemctl start radarr
#sudo systemctl start headphones
sudo systemctl start nzbget
sudo systemctl start plexpy
sudo systemctl start ombi
sudo systemctl restart nginx
