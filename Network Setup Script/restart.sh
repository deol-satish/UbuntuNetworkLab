#!/bin/bash

# Set basic configuration values
set -x

# Source the settings file
if [ ! -f ./utils/settings.sh ]; then
    echo "Error: settings.sh file not found"
    exit 1
fi

source ./utils/settings.sh


ssh root@"$router_ipaddr" "$sudo shutdown -r now" &
ssh root@"$client1_ipaddr" "$sudo shutdown -r now" &
ssh root@"$client2_ipaddr" "$sudo shutdown -r now" &
ssh root@"$server_ipaddr" "$sudo shutdown -r now" &


