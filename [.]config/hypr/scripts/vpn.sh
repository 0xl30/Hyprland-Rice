#!/bin/bash

# Get NordVPN status
status=$(nordvpn status | grep Status | awk '{print $4}')

# Check the status and print the corresponding icon
if [ "$status" == "Connected" ]; then
    echo ""
else
    echo ""
fi
