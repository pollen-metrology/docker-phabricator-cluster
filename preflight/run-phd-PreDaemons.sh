#!/bin/bash

# Reload configuration
source /config.saved

mkdir -p /var/tmp/phd/log
mkdir -p /var/tmp/phd/pid


if [ "$SCRIPT_BEFORE_DAEMONS" != "" ]; then
  pushd /srv/phabricator/phabricator
  $SCRIPT_BEFORE_DAEMONS
  popd
fi

exec cat
