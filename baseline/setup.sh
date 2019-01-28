#!/bin/bash

set -e
set -x

add-apt-repository ppa:certbot/certbot
apt-get update
apt install -y curl git

curl -sL https://deb.nodesource.com/setup_8.x | bash -


# Test to make sure we're not running Git 2.11, otherwise, abort the image bake right now (this prevents
# bad images from being pushed to the index).
if [ "$(git --version)" == *"2.11"* ]; then
  echo "Bad version of Git detected: $(git --version).  Aborting image creation!"
  exit 1
fi

# Install requirements
apt install -y nginx php-fpm php-mbstring php-mysql php-curl php-gd php-ldap php-fileinfo php-posix php-json php-iconv php-ctype php-zip php-sockets openssl nodejs ca-certificates sudo php-xmlwriter php-opcache imagemagick postfix python-pygments php-apcu

# Websocket module is needed for Aphlict
npm install -g ws

# Install a few extra things
apt install -y mariadb-server vim 

# Initial Mariadb setup
/usr/bin/mysql_install_db --datadir="/var/lib/mysql" --user=mysql --auth-root-authentication-method=socket


# Create users and groups
echo "nginx:x:497:495:user for nginx:/var/lib/nginx:/bin/false" >> /etc/passwd
echo "nginx:!:495:" >> /etc/group
echo "PHABRICATOR_VCS_USER:x:2000:2000:user for phabricator vcs access:/srv/phabricator:/bin/bash" >> /etc/passwd
echo "PHABRICATOR_DAEMON_USER:x:2001:2000:user for phabricator daemons:/srv/phabricator:/bin/bash" >> /etc/passwd
echo "PHABRICATOR_WWW_USER:x:2002:2000:user for phabricator web service:/srv/phabricator:/bin/bash" >> /etc/passwd
echo "wwwgrp-phabricator:!:2000:nginx,PHABRICATOR_VCS_USER,PHABRICATOR_DAEMON_USER,PHABRICATOR_WWW_USER" >> /etc/group

# Set up the Phabricator code base
mkdir /srv/phabricator
cd /srv/phabricator
git clone https://www.github.com/phacility/libphutil.git /srv/phabricator/libphutil
git clone https://www.github.com/phacility/arcanist.git /srv/phabricator/arcanist
git clone https://www.github.com/phacility/phabricator.git /srv/phabricator/phabricator
git clone https://www.github.com/PHPOffice/PHPExcel.git /srv/phabricator/PHPExcel

echo "
[client]
ssl
" >> /srv/phabricator/.my.cnf

cd /

# Clone Let's Encrypt
apt install -y python-certbot-nginx
cd /
