#!/bin/bash

set -e
set -x

# Install requirements
zypper --gpg-auto-import-keys --non-interactive in --force-resolution nginx php7-fpm php7-mbstring php7-mysql php7-curl php7-pcntl php7-gd php7-openssl php7-ldap php7-fileinfo php7-posix php7-json php7-iconv php7-ctype php7-zip php7-sockets which python3-Pygments nodejs ca-certificates ca-certificates-mozilla ca-certificates-cacert sudo subversion mercurial php7-xmlwriter php7-opcache ImageMagick postfix glibc-locale git python-pip npm8 hostname

npm install -g ws
pip install supervisor

# Build and install APCu
zypper --non-interactive install --force-resolution autoconf automake binutils cpp gcc gcc-c++ glibc-devel libatomic1 libgomp1 libitm1 libltdl7 libmpc3 libpcre16-0 libpcrecpp0 libpcreposix0 libstdc++-devel libtool libtsan0 libxml2-devel libxml2-tools linux-glibc-devel m4 make ncurses-devel pcre-devel php7-devel php7-pear php7-zlib pkg-config readline-devel tack xz-devel zlib-devel php7-APCu

#zypper --non-interactive remove --force-resolution autoconf automake binutils cpp cpp48 gcc gcc48 glibc-devel libasan0 libatomic1 libcloog-isl4 libgomp1 libisl10 libitm1 libltdl7 libmpc3 libmpfr4 libpcre16-0 libpcrecpp0 libpcreposix0 libstdc++-devel libstdc++48-devel libtool libtsan0 libxml2-devel libxml2-tools linux-glibc-devel m4 ncurses-devel pcre-devel php7-devel php7-pear pkg-config readline-devel tack xz-devel zlib-devel

# Remove cached things that pecl left in /tmp/
rm -rf /tmp/*

# Install a few extra things
zypper --non-interactive install --force-resolution mariadb-client vim vim-data

# Force reinstall cronie
zypper --non-interactive install -f cronie

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

cd /

# Clone Let's Encrypt
git clone https://github.com/letsencrypt/letsencrypt /srv/letsencrypt
cd /srv/letsencrypt
./letsencrypt-auto-source/letsencrypt-auto --help
cd /
