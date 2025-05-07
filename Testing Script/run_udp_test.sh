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


ssh root@"$router_ipaddr" "rm -f *.json; rm *.pcap; rm *udp*.txt" 
ssh root@"$client1_ipaddr" "rm -f *.json; rm *.pcap; rm *udp*.txt"
ssh root@"$client2_ipaddr" "rm -f *.json; rm *.pcap; rm *udp*.txt"
ssh root@"$server_ipaddr" "rm -f *.json; rm *.pcap; rm *udp*.txt"

testname="iperf3_d${duration}"

echo "Set TCP CC on clients"
ssh root@"$client1_ipaddr" "sudo sysctl -w net.ipv4.tcp_congestion_control=$tcp1"
ssh root@"$client2_ipaddr" "sudo sysctl -w net.ipv4.tcp_congestion_control=$tcp2"

echo "Starting iperf3 server instances"
# ssh root@"$server_ipaddr" "nohup iperf3 -s -p 5101 > /dev/null 2>&1 &"
# ssh root@"$server_ipaddr" "nohup iperf3 -s -p 5102 > /dev/null 2>&1 &"
# ssh root@"$server_ipaddr" "nohup iperf3 -s -p 5101 > iperf3_server_${tcp1}_${testname}.json 2>&1 &"
ssh root@"$server_ipaddr" "nohup iperf3 -s -p 5102 -J > iperf3_server_${tcp2}_${testname}.json 2>&1 &"
ssh root@"$server_ipaddr" "stdbuf -oL ./udp_prague/udp_prague_receiver -p 5106 > udp_prague_receiver_${testname}.json" &


echo "Start tcpdump on the server to capture traffic"
ssh root@"$server_ipaddr" "sudo nohup tcpdump -i ens37 -w /home/ubuntu/pcap_server_${testname}.pcap > /dev/null 2>&1 &"



# Wait for servers to start
sleep 2
echo "Start iperf3 Test"
# ssh root@"$client1_ipaddr" "iperf3 -c 192.168.2.2 -t $duration -p 5101 -J > iperf3_client_${tcp1}_${testname}.json" &
ssh root@"$client2_ipaddr" "iperf3 -c 192.168.2.2 -t $duration -p 5102 -J > iperf3_client_${tcp2}_${testname}.json" &
ssh root@"$client1_ipaddr" "./udp_prague/udp_prague_sender -a 192.168.2.2 -p 5106 -c > udp_prague_sender_${testname}.txt" &


echo "sending completed"

sleep $duration
ssh root@"$router_ipaddr" "sudo pkill -f iperf3;sudo pkill -f tcpdump;" 
ssh root@"$client1_ipaddr" "sudo pkill -f iperf3;sudo pkill -f tcpdump;sudo pkill -f udp_prague_sender;"
ssh root@"$client2_ipaddr" "sudo pkill -f iperf3;sudo pkill -f tcpdump;sudo pkill -f udp_prague_sender;"
ssh root@"$server_ipaddr" "sudo pkill -f iperf3;sudo pkill -f tcpdump;sudo pkill -f udp_prague_receiver;"



# SCP the generated files (JSON and PCAP) to the newly created folder on WSL

echo "Copying files to windows WSL folder..."

echo "Starting downloading data"

# Generate timestamp
timestamp=$(date +"%Y-%m-%d-%H-%M-%S")

# Create main directory with timestamp
base_dir="./data/udp_net_${timestamp}"
mkdir -p "$base_dir"

# Copy server-side JSON and PCAP files to the directory in WSL
scp root@"$server_ipaddr":*.json "$base_dir"/
scp root@"$server_ipaddr":*.pcap "$base_dir"/
scp root@"$server_ipaddr":*.txt "$base_dir"/

# Copy client-side JSON files to the directory in WSL
scp root@"$client1_ipaddr":*.json "$base_dir"/
scp root@"$client2_ipaddr":*.json "$base_dir"/
scp root@"$client1_ipaddr":*.txt "$base_dir"/
scp root@"$client2_ipaddr":*.txt "$base_dir"/

echo "File transfer complete."

# If successful
echo "Test complete"
exit 0
