#!/bin/bash

# Set basic configuration values
set -x

# Source the settings file
if [ ! -f ../utils/settings.sh ]; then
    echo "Error: settings.sh file not found"
    exit 1
fi
source ../utils/settings.sh

mkdir -p "$base_dir"

# Kill any running iperf3 instances
ssh root@"$router_ipaddr" "sudo pkill -f iperf3" 
ssh root@"$client1_ipaddr" "sudo pkill -f iperf3"
ssh root@"$client2_ipaddr" "sudo pkill -f iperf3"
ssh root@"$server_ipaddr" "sudo pkill -f iperf3"


ssh root@"$router_ipaddr" "cd /home/ubuntu/; rm *.json; rm *.pcap" 
ssh root@"$client1_ipaddr" "cd /home/ubuntu/; rm *.json; rm *.pcap"
ssh root@"$client2_ipaddr" "cd /home/ubuntu/; rm *.json; rm *.pcap"
ssh root@"$server_ipaddr" "cd /home/ubuntu/; rm *.json; rm *.pcap"

testname="basic_iperf3_test"

echo "Set TCP CC on clients"
ssh root@"$client1_ipaddr" "sudo sysctl -w net.ipv4.tcp_congestion_control=$tcp1"
ssh root@"$client2_ipaddr" "sudo sysctl -w net.ipv4.tcp_congestion_control=$tcp2"

echo "Starting iperf3 server instances"
# ssh root@"$server_ipaddr" "nohup iperf3 -s -p 5101 > /dev/null 2>&1 &"
# ssh root@"$server_ipaddr" "nohup iperf3 -s -p 5102 > /dev/null 2>&1 &"
ssh root@"$server_ipaddr" "cd /home/ubuntu/; nohup iperf3 -s -p 5101 > iperf3_server_${tcp1}_${testname}.json 2>&1 &"
ssh root@"$server_ipaddr" "cd /home/ubuntu/; nohup iperf3 -s -p 5102 > iperf3_server_${tcp2}_${testname}.json 2>&1 &"

echo "Start tcpdump on the server to capture traffic"
ssh root@"$server_ipaddr" "sudo nohup tcpdump -i ens37 -w /home/ubuntu/pcap_server_${testname}.pcap > /dev/null 2>&1 &"



# Wait for servers to start
sleep 2
echo "Start iperf3 Test"
ssh root@"$client1_ipaddr" "cd /home/ubuntu/; iperf3 -c 192.168.3.2 -t $duration -p 5101 -J > iperf3_client_${tcp1}_${testname}.json" &
ssh root@"$client2_ipaddr" "cd /home/ubuntu/; iperf3 -c 192.168.3.2 -t $duration -p 5102 -J > iperf3_client_${tcp2}_${testname}.json" &


Wait for the iperf3 tests to finish
wait

# SCP the generated files (JSON and PCAP) to the newly created folder on WSL

echo "Copying files to windows WSL folder..."

# Copy server-side JSON and PCAP files to the directory in WSL
scp root@"$server_ipaddr":/home/ubuntu/iperf3_server_${tcp1}_${testname}.json "$base_dir"/
scp root@"$server_ipaddr":/home/ubuntu/iperf3_server_${tcp2}_${testname}.json "$base_dir"/
scp root@"$server_ipaddr":/home/ubuntu/pcap_server_${testname}.pcap "$base_dir"/

# Copy client-side JSON files to the directory in WSL
scp root@"$client1_ipaddr":/home/ubuntu/iperf3_client_${tcp1}_${testname}.json "$base_dir"/
scp root@"$client2_ipaddr":/home/ubuntu/iperf3_client_${tcp2}_${testname}.json "$base_dir"/

echo "File transfer complete."

# If successful
echo "Test complete"
exit 0
