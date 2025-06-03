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
ssh root@"$router_ipaddr" "sudo killall iperf3;sudo killall tcpdump;" 
ssh root@"$client1_ipaddr" "sudo killall iperf3;sudo killall tcpdump;sudo killall udp_prague_sender;"
ssh root@"$client2_ipaddr" "sudo killall iperf3;sudo killall tcpdump;sudo killall udp_prague_sender;"
ssh root@"$server_ipaddr" "sudo killall iperf3;sudo killall tcpdump;sudo killall udp_prague_receiver;"

ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 10ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1: handle 2: tbf rate 8mbit burst 32kbit latency 10ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 2:1 handle 3: dualpi2"

# If successful
echo "Router Config Setup"
exit 0
