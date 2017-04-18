######
##Edit SSH Port
######
nano /etc/ssh/sshd_config
sudo systemctl restart sshd

#######
###Upload Public Key
######
mkdir ~/.ssh
chmod 0700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 0644 ~/.ssh/authorized_keys

######
##Update
######
apt-get update
apt-get upgrade -y
apt-get dist-upgrade -y

######
##Add Repos & Keys
######
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb http://download.mono-project.com/repo/debian wheezy main" | sudo tee /etc/apt/sources.list.d/mono-xamarin.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FDA5DFFC
echo "deb http://apt.sonarr.tv/ master main" | sudo tee /etc/apt/sources.list.d/sonarr.list

########
###Insall Dependencies
#########
apt get update 
apt-get install -yqq sudo software-properties-common ufw mono-devel unzip zip libmono-cil-dev curl mediainfo nginx php5-fpm php5-mysql php5.0-sqlite fuse unionfs-fuse

#######
##Make Directories
#######
mkdir -p /home/{acd-movies,acd-tv,acd-kidsm,acd-kidstv,plex-movies-r,plex-kidsm-r,plex-tv-r,plex-kidstv-r,plextemp,movies,movies-kids,tv,tv-kids,scripts,scripts/logs}
mkdir -p /home/{gdrive-movies,gdrive-tv,gdrive-kidsm,gdrive-kidstv}

########
###Install Apps####
########

##Plex
bash -c "$(wget -qO - https://raw.githubusercontent.com/mrworf/plexupdate/master/extras/installer.sh)"

##Trakt.tv Plugin
wget https://github.com/trakt/Plex-Trakt-Scrobbler/archive/master.zip -O Plex-Trakt-Scrobbler.zip
unzip Plex-Trakt-Scrobbler.zip && rm -f Plex-Trakt-Scrobbler.zip
sudo systemctl stop plexmediaserver
cp -r Plex-Trakt-Scrobbler-*/Trakttv.bundle "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Plug-ins/"
sudo systemctl start plexmediaserver

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

##Headphones
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

##rclone
cd /tmp
curl -O http://downloads.rclone.org/rclone-current-linux-amd64.zip
unzip rclone-current-linux-amd64.zip && rm -f rclone-current-linux-amd64.zip
cd rclon-*-linux-amd64
sudo cp rclone /usr/bin/
sudo chown root:root /usr/bin/rclone
sudo chmod 755 /usr/bin/rclone
rclone config

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
sudo ufw enable

########
####Systemd Files
########
cp /tmp/htpcserver/systemd/* /etc/systemd/system/
sudo systemctl enable sonarr
sudo systemctl enable radarr
sudo systemctl enable headphones
sudo systemctl enable nzbget
sudo systemctl enable plexpy
sudo systemctl enable ombi 
sudo systemctl start sonarr
sudo systemctl start radarr
sudo systemctl start headphones
sudo systemctl start nzbget
sudo systemctl start plexpy
sudo systemctl start ombi

####
##Rclone Scripts
####
touch mount-m.cron mount-tv.cron upload-m.cron upload-tv.cron mount-kidsm.cron mount-kidstv.cron upload-kidsm.cron upload-kidstv.cron
touch /home/plex-tv-r/mountcheck /home/plex-movies-r/mountcheck /home/plex-kidstv-r/mountcheck /home/plex-kidsm-r/mountcheck

