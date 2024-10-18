#!/bin/bash

# Get NordVPN status
status=$(warp-cli status | grep Status | awk '{print $3}')

# Check the status and print the corresponding icon
if [ "$status" == "Connected" ]; then
    echo ""
else
    echo ""
fi
