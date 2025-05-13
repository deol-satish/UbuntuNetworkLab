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
ssh root@"$router_ipaddr" "sudo killall iperf3" 
ssh root@"$client1_ipaddr" "sudo killall iperf3"
ssh root@"$client2_ipaddr" "sudo killall iperf3"
ssh root@"$server_ipaddr" "sudo killall iperf3"


ssh root@"$router_ipaddr" "cd /home/ubuntu/; rm *.json; rm *.pcap" 
ssh root@"$client1_ipaddr" "cd /home/ubuntu/; rm *.json; rm *.pcap"
ssh root@"$client2_ipaddr" "cd /home/ubuntu/; rm *.json; rm *.pcap"
ssh root@"$server_ipaddr" "cd /home/ubuntu/; rm *.json; rm *.pcap"


ssh root@"$router_ipaddr" "cd /home/ubuntu/; rm *.json; rm *.pcap; rm *dmesg*.txt" 
ssh root@"$client1_ipaddr" "cd /home/ubuntu/;rm *.json; rm *.pcap;"
ssh root@"$client2_ipaddr" "cd /home/ubuntu/;rm *.json; rm *.pcap;"
ssh root@"$server_ipaddr" "cd /home/ubuntu/; rm *.json; rm *.pcap;"

ssh root@"$router_ipaddr" "sudo dmesg -C"

testname="iperf3_d${duration}"

echo "Set TCP CC on clients"
ssh root@"$client1_ipaddr" "sudo sysctl -w net.ipv4.tcp_congestion_control=$tcp1"
ssh root@"$client2_ipaddr" "sudo sysctl -w net.ipv4.tcp_congestion_control=$tcp2"

ssh root@"$client1_ipaddr" "sudo sysctl -w net.ipv4.tcp_ecn=$tcp1_ecn"
ssh root@"$client2_ipaddr" "sudo sysctl -w net.ipv4.tcp_ecn=$tcp2_ecn"

echo "Starting iperf3 server instances"
# ssh root@"$server_ipaddr" "nohup iperf3 -s -p 5101 > /dev/null 2>&1 &"
# ssh root@"$server_ipaddr" "nohup iperf3 -s -p 5102 > /dev/null 2>&1 &"
ssh root@"$server_ipaddr" "cd /home/ubuntu/; nohup iperf3 -s -p 5101 -J > iperf3_server_${tcp1}_${testname}.json 2>&1 &"
ssh root@"$server_ipaddr" "cd /home/ubuntu/; nohup iperf3 -s -p 5102 -J > iperf3_server_${tcp2}_${testname}.json 2>&1 &"

echo "Start tcpdump on the server to capture traffic"
ssh root@"$server_ipaddr" "sudo nohup tcpdump -i ens37 -w /home/ubuntu/pcap_server_${testname}.pcap > /dev/null 2>&1 &"



# Wait for servers to start
sleep 2
echo "Start iperf3 Test"
ssh root@"$client1_ipaddr" "cd /home/ubuntu/; iperf3 -c 192.168.2.2 -t $duration -p 5101 -J > iperf3_client_${tcp1}_${testname}.json" &
ssh root@"$client2_ipaddr" "cd /home/ubuntu/; iperf3 -c 192.168.2.2 -t $duration -p 5102 -J > iperf3_client_${tcp2}_${testname}.json" &


wait

# SCP the generated files (JSON and PCAP) to the newly created folder on WSL

echo "Copying files to windows WSL folder..."

echo "Starting downloading data"

# Generate timestamp
timestamp=$(date +"%Y-%m-%d-%H-%M-%S")

# Create main directory with timestamp
base_dir="./data/net_${timestamp}"
mkdir -p "$base_dir"

ssh root@"$router_ipaddr" "dmesg > "dmesg_${testname}_${timestamp}.txt"" 


# Copy server-side JSON and PCAP files to the directory in WSL
scp root@"$server_ipaddr":/home/ubuntu/*.json "$base_dir"/
scp root@"$server_ipaddr":/home/ubuntu/*.pcap "$base_dir"/

# Copy client-side JSON files to the directory in WSL
scp root@"$client1_ipaddr":/home/ubuntu/*.json "$base_dir"/
scp root@"$client2_ipaddr":/home/ubuntu/*.json "$base_dir"/
scp root@"$router_ipaddr":*dmesg*.txt "$base_dir"/

echo "File transfer complete."

# If successful
echo "Test complete"
exit 0
