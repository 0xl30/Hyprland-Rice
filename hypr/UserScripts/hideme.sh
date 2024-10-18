#!/bin/bash

# Get NordVPN status
status=$(hideme -s | grep VPN | awk '{print $3}')

# Check the status and print the corresponding icon
if [ "$status" == "running" ]; then
    echo ""
else
    echo ""
fi
