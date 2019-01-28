#!/bin/bash -x

exec 1>&2

export SYSTEMD_NO_WRAP=true
export PIDFILE=/var/spool/postfix/pid/master.pid
mkdir -pv /var/spool/postfix/pid
. /etc/sysconfig/postfix

#/etc/postfix/system/config_postfix
#/etc/postfix/system/update_chroot
#/etc/postfix/system/update_postmaps

exec /usr/lib/postfix/sbin/master
