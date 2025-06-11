#!/bin/bash

# Check if ProtonVPN is active via NetworkManager
status=$(nmcli connection show --active | grep -i "protonvpn" | wc -l)

# Check the status and print the corresponding icon
if [ "$status" -gt 0 ]; then
    echo ""  # Locked icon for connected
else
    echo ""  # Unlocked icon for disconnected
fi
