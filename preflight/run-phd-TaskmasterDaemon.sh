#!/bin/bash

# Reload configuration
source /config.saved

sv start PhabricatorPreDaemons || exit 1

CLASS="PhabricatorTaskmasterDaemon"
LABEL="TaskMaster"
LOGFILE="/var/tmp/phd/log/taskmaster.log"
CFG_FILENAME=tm.cfg

echo "{\"daemonize\": false, \"log\":\"$LOGFILE\", \"daemons\": [{\"class\": \"$CLASS\", \"label\":\"$LABEL\"}]}" > /tmp/$CFG_FILENAME
exec sudo -u "$PHABRICATOR_DAEMON_USER" /srv/phabricator/phabricator/scripts/daemon/phd-daemon  < /tmp/$CFG_FILENAME
