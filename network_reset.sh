#!/bin/bash

# Set basic configuration values
set -x

# Source the settings file
if [ ! -f ./utils/settings.sh ]; then
    echo "Error: settings.sh file not found"
    exit 1
fi
source ./utils/settings.sh


# Kill any running iperf3 instances
ssh root@"$router_ipaddr" "sudo pkill -f iperf3;sudo pkill -f tcpdump;" 
ssh root@"$client1_ipaddr" "sudo pkill -f iperf3;sudo pkill -f tcpdump;sudo pkill -f udp_prague_sender;"
ssh root@"$client2_ipaddr" "sudo pkill -f iperf3;sudo pkill -f tcpdump;sudo pkill -f udp_prague_sender;"
ssh root@"$server_ipaddr" "sudo pkill -f iperf3;sudo pkill -f tcpdump;sudo pkill -f udp_prague_receiver;"

echo "Reset Router AQM Config for interface ens37"
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root"

# If successful
echo "Router Config Setup"
exit 0
