#!/usr/bin/expect

set timeout 20

spawn bash -c "$(wget -qO - https://raw.githubusercontent.com/mrworf/plexupdate/master/extras/installer.sh)"

expect "Directory to install into: /opt/plexupdate" { send "\r" }

expect "Do you want to install the latest PlexPass releases? (requires PlexPass account) [Y/n]" { send "Y\r" }

expect "PlexPass Email Address:" { send "j.comino@yahoo.com\r" }

expect "PlexPass Password:" { send "Righteous123\r" }

expect "Would you like to automatically install the latest release when it is downloaded? [Y/n]" { send "Y\r" }

expect "When using the auto-install option, would you like to check if the server is in use before upgrading? [Y/n]" { send "Y\r" } 

expect "Plex Server IP/DNS name: 127.0.0.1" { send "\r" }

expect "Plex Server Port: 32400" { send "\r" }

expect "Would you like to set up automatic daily updates for Plex? [Y/n]" { send "Y\r" }

expect "Do you want to log the daily update runs to syslog so you can examine the output later? [N/y]" { send "N\r" }

expect "Should cron send you an email if an update is available/installed? [Y/n]" { send "Y\r" } 

expect "Configuration complete. Would you like to run plexupdate with these settings now? [Y/n]" { send "Y\r" } 
