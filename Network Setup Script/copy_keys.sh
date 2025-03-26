#!/bin/bash

# Set basic configuration values
set -x

# Source the settings file
if [ ! -f ./utils/settings.sh ]; then
    echo "Error: settings.sh file not found"
    exit 1
fi

source ./utils/settings.sh

ssh-copy-id root@"$router_ipaddr"
ssh-copy-id root@"$client1_ipaddr"
ssh-copy-id root@"$client2_ipaddr"
ssh-copy-id root@"$server_ipaddr"