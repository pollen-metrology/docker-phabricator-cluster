#!/bin/bash

# Reload configuration
source /config.saved

sv start PhabricatorTriggerDaemon
sv start PhabricatorTaskmasterDaemon
sv start PhabricatorRepositoryPullLocalDaemon

if [ "$SCRIPT_AFTER_DAEMONS" != "" ]; then
    pushd /srv/phabricator/phabricator
    $SCRIPT_AFTER_DAEMONS
    popd
fi

exec cat

