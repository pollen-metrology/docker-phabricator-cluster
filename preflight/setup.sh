#!/bin/bash

set -e
set -x

# Move preflight files to their locations
mkdir /app
mkdir /app/startup
cd /preflight

mv nginx.conf /app/nginx.conf
mv nginx.ssl.conf /app/nginx.ssl.conf
mv server-https-letsencrypt.conf /app/disabled-server-https-letsencrypt.conf
mv server-https-manual.conf /app/disabled-server-https-manual.conf

mv fastcgi.conf /app/fastcgi.conf

mkdir -p /etc/service/mariadb
mv run-mariadb.sh /etc/service/mariadb/run
chmod +x /etc/service/mariadb/run

mkdir -p /etc/service/PhabricatorPreDaemons
mv run-phd-PreDaemons.sh /etc/service/PhabricatorPreDaemons/run
chmod +x /etc/service/PhabricatorPreDaemons/run

mkdir -p /etc/service/PhabricatorRepositoryPullLocalDaemon
mv run-phd-RepositoryPullLocalDaemon.sh /etc/service/PhabricatorRepositoryPullLocalDaemon/run
chmod +x /etc/service/PhabricatorRepositoryPullLocalDaemon/run

mkdir -p /etc/service/PhabricatorTaskmasterDaemon
mv run-phd-TaskmasterDaemon.sh /etc/service/PhabricatorTaskmasterDaemon/run
chmod +x /etc/service/PhabricatorTaskmasterDaemon/run

mkdir -p /etc/service/PhabricatorTriggerDaemon
mv run-phd-TriggerDaemon.sh /etc/service/PhabricatorTriggerDaemon/run
chmod +x /etc/service/PhabricatorTriggerDaemon/run

mkdir -p /etc/service/PhabricatorPostDaemons
mv run-phd-PostDaemons.sh /etc/service/PhabricatorPostDaemons/run
chmod +x /etc/service/PhabricatorPostDaemons/run

mkdir -p /etc/service/sshd/
mv run-ssh.sh /etc/service/sshd/run
chmod +x /etc/service/sshd/run

mkdir -p /etc/service/aphlict/
mv run-aphlict.sh /etc/service/aphlict/run
chmod +x /etc/service/aphlict/run

mkdir -p /etc/service/iomonitor
mv run-iomonitor.sh /etc/service/iomonitor/run
chmod +x /etc/service/iomonitor/run

mkdir -p /etc/service/postfix
mv run-postfix.sh /etc/service/postfix/run
chmod +x /etc/service/postfix/run

mkdir /etc/service/letsencrypt
mv letsencrypt.sh /etc/service/letsencrypt/run
chmod +x /etc/service/letsencrypt/run

mkdir /etc/service/nginx
mv run-nginx.sh /etc/service/nginx/run
chmod +x /etc/service/nginx/run

mkdir /etc/service/nginx-ssl
mv run-nginx-ssl.sh /etc/service/nginx-ssl/run
chmod +x /etc/service/nginx-ssl/run

mkdir /etc/service/php-fpm
mv run-phpfpm.sh /etc/service/php-fpm/run
chmod +x /etc/service/php-fpm/run

mv 10-boot-conf /app/startup/10-boot-conf
mv 15-https-conf /app/startup/15-https-conf

mkdir -p /etc/php/7.2/fpm/
mv php-fpm.conf /etc/php/7.2/fpm/php-fpm.conf.template
mv php.ini      /etc/php/7.2/fpm/php.ini

mkdir -pv /run/watch
mkdir /etc/phabricator-ssh
mv sshd_config.phabricator /etc/phabricator-ssh/sshd_config.phabricator.template
mv phabricator-ssh-hook.sh /etc/phabricator-ssh/phabricator-ssh-hook.sh.template
mkdir /opt/iomonitor
mv iomonitor /opt/iomonitor
rm setup.sh
cd /
ls /preflight
rm -rf /preflight # This should now be empty; it's an error if it's not.


# Mysql setup
/usr/bin/mysqld_safe &
sleep 5
echo "CREATE USER 'phabricator'@'localhost' IDENTIFIED BY 'phabricator';" | mysql
/srv/phabricator/phabricator/bin/config set mysql.user phabricator
/srv/phabricator/phabricator/bin/config set mysql.pass phabricator
/srv/phabricator/phabricator/bin/config set mysql.host 127.0.0.1
echo "GRANT ALL PRIVILEGES ON *.* TO 'phabricator'@'localhost';" | mysql
/srv/phabricator/phabricator/bin/storage upgrade --force
kill `cat /var/run/mysqld/mysqld.pid`

# Install PHPExcel
echo '' >> /etc/php/7.2/fpm/php-fpm.conf
echo 'php_value[include_path] = "/srv/phabricator/PHPExcel/Classes"' >> /etc/php/7.2/fpm/php-fpm.conf

echo "" >> /etc/ssh/sshd_config
echo "Port 22" >> /etc/ssh/sshd_config

# Configure Phabricator SSH service
chown root:root /etc/phabricator-ssh/*

# Workaround for https://gist.github.com/porjo/35ea98cb64553c0c718a
chmod u+s /usr/sbin/postdrop
chmod u+s /usr/sbin/postqueue

/app/startup/10-boot-conf
/app/startup/15-https-conf
