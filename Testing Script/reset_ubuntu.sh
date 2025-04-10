#!/bin/bash

# Set basic configuration values
set -x

# Source the settings file
if [ ! -f ../utils/settings.sh ]; then
    echo "Error: settings.sh file not found"
    exit 1
fi
source ../utils/settings.sh


# Kill any running iperf3 instances
ssh root@"$router_ipaddr" "sudo pkill -f iperf3;sudo pkill -f tcpdump;" 
ssh root@"$client1_ipaddr" "sudo pkill -f iperf3;sudo pkill -f tcpdump;sudo pkill -f udp_prague_sender;"
ssh root@"$client2_ipaddr" "sudo pkill -f iperf3;sudo pkill -f tcpdump;sudo pkill -f udp_prague_sender;"
ssh root@"$server_ipaddr" "sudo pkill -f iperf3;sudo pkill -f tcpdump;sudo pkill -f udp_prague_receiver;"


ssh root@"$router_ipaddr" "cd /home/ubuntu/Desktop; rm -f *.json; rm *.pcap" 
ssh root@"$client1_ipaddr" "cd /home/ubuntu/Desktop; rm -f *.json; rm *.pcap"
ssh root@"$client2_ipaddr" "cd /home/ubuntu/Desktop; rm -f *.json; rm *.pcap"
ssh root@"$server_ipaddr" "cd /home/ubuntu/Desktop; rm -f *.json; rm *.pcap"


# If successful
echo "Test complete"
exit 0
