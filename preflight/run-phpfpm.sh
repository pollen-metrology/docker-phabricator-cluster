#!/bin/bash
exec 2>&1

mkdir -p /run/php/
exec php-fpm7.2 --nodaemonize
