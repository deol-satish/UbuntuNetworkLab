#!/bin/bash

# Set basic configuration values
set -x

source ./utils/settings.sh

# Set up the network
ssh -p "$routerport" -i "$sshkeypath" ubuntu@"$vmhostaddr" "cd Desktop; mkdir testfolder"


# completed
echo "Test complete"
exit 0

# error
out() {
    echo "Abort test"
    exit 1
}