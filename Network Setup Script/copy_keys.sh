#!/bin/bash

# Set basic configuration values
set -x

# Source the settings file
if [ ! -f ./utils/settings.sh ]; then
    echo "Error: settings.sh file not found"
    exit 1
fi
source ./utils/settings.sh

# Define SSH key and remote users for the machines
SSH_KEY="$HOME/.ssh/id_rsa.pub"
REMOTE_USER="root"   # Replace with the actual username

# Define IP addresses for the machines
# server_ipaddr="192.168.3.2"   # IP address for the server
# client1_ipaddr="192.168.3.3"  # IP address for client 1
# client2_ipaddr="192.168.3.4"  # IP address for client 2
# router_ipaddr="192.168.3.1"   # IP address for the router

# Function to set up passwordless SSH on a remote host
setup_ssh_key() {
  local remote_host=$1  # IP address of the remote host

  # Create the .ssh directory and authorized_keys file if they do not exist
  ssh "$REMOTE_USER@$remote_host" "mkdir -p ~/.ssh && chmod 700 ~/.ssh && touch ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"

  # Copy the public SSH key to the remote server
  cat "$SSH_KEY" | ssh "$REMOTE_USER@$remote_host" "cat >> ~/.ssh/authorized_keys"

  # Test passwordless SSH login
  ssh "$REMOTE_USER@$remote_host" "echo Passwordless SSH setup successful on $remote_host!"
}

# Set up passwordless SSH for each machine
echo "Setting up passwordless SSH for server..."
setup_ssh_key "$server_ipaddr"

echo "Setting up passwordless SSH for client 1..."
setup_ssh_key "$client1_ipaddr"

echo "Setting up passwordless SSH for client 2..."
setup_ssh_key "$client2_ipaddr"

echo "Setting up passwordless SSH for router..."
setup_ssh_key "$router_ipaddr"

echo "Passwordless SSH setup completed for all machines."
