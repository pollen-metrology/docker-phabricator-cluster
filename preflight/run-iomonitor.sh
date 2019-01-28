#!/bin/bash

# Source configuration
source /config.saved

if [ "$DISABLE_IOMONITOR" != "true" ]; then
    # Run IO monitor
    /opt/iomonitor/iomonitor
fi
