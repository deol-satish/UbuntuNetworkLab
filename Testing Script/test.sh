#!/bin/bash

# Set basic configuration values
set -x

# Source the settings file
if [ ! -f ../utils/settings.sh ]; then
    echo "Error: settings.sh file not found"
    exit 1
fi
source ../utils/settings.sh


echo "Copying files to windows WSL folder..."

echo "Starting downloading data"

# Generate timestamp
timestamp=$(date +"%Y-%m-%d-%H-%M-%S")

# Create main directory with timestamp
base_dir="./data/udp_net_${timestamp}"
mkdir -p "$base_dir"

ssh root@"$router_ipaddr" "sudo killall iperf3;sudo killall tcpdump;" 
ssh root@"$client1_ipaddr" "sudo killall iperf3;sudo killall tcpdump;sudo killall udp_prague_sender;"
ssh root@"$client2_ipaddr" "sudo killall iperf3;sudo killall tcpdump;sudo killall udp_prague_sender;"
ssh root@"$server_ipaddr" "sudo killall iperf3;sudo killall tcpdump;sudo killall udp_prague_receiver;"

# Copy server-side JSON and PCAP files to the directory in WSL
scp root@"$server_ipaddr":*.json "$base_dir"/
scp root@"$server_ipaddr":*.pcap "$base_dir"/
scp root@"$server_ipaddr":*.txt "$base_dir"/

# Copy client-side JSON files to the directory in WSL
scp root@"$client1_ipaddr":*.json "$base_dir"/
scp root@"$client1_ipaddr":*.pcap "$base_dir"/
scp root@"$client1_ipaddr":*.txt "$base_dir"/

scp root@"$client2_ipaddr":*.json "$base_dir"/
scp root@"$client2_ipaddr":*.pcap "$base_dir"/
scp root@"$client2_ipaddr":*.txt "$base_dir"/

echo "File transfer complete."

# If successful
echo "Test complete"
exit 0
