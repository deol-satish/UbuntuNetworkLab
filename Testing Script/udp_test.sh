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
ssh root@"$router_ipaddr" "sudo killall iperf3;sudo killall tcpdump;" 
ssh root@"$client1_ipaddr" "sudo killall iperf3;sudo killall tcpdump;sudo killall udp_prague_sender;"
ssh root@"$client2_ipaddr" "sudo killall iperf3;sudo killall tcpdump;sudo killall udp_prague_sender;"
ssh root@"$server_ipaddr" "sudo killall iperf3;sudo killall tcpdump;sudo killall udp_prague_receiver;"


ssh root@"$router_ipaddr" "rm -f *.json; rm *.pcap; rm *udp*.txt; rm *dmesg*.txt" 
ssh root@"$client1_ipaddr" "rm -f *.json; rm *.pcap; rm *udp*.txt"
ssh root@"$client2_ipaddr" "rm -f *.json; rm *.pcap; rm *udp*.txt"
ssh root@"$server_ipaddr" "rm -f *.json; rm *.pcap; rm *udp*.txt"

# ssh root@"$router_ipaddr" "sudo dmesg -C"



testname="iperf3_d${duration}"

echo "Set TCP CC on clients"
ssh root@"$client1_ipaddr" "sudo sysctl -w net.ipv4.tcp_congestion_control=$tcp1"
ssh root@"$client2_ipaddr" "sudo sysctl -w net.ipv4.tcp_congestion_control=$tcp2"

ssh root@"$client1_ipaddr" "sudo sysctl -w net.ipv4.tcp_ecn=$tcp1_ecn"
ssh root@"$client2_ipaddr" "sudo sysctl -w net.ipv4.tcp_ecn=$tcp2_ecn"

ssh root@"$router_ipaddr" "sudo sysctl -w net.ipv4.tcp_ecn=1"
ssh root@"$server_ipaddr" "sudo sysctl -w net.ipv4.tcp_ecn=1"

echo "Starting iperf3 server instances"
# ssh root@"$server_ipaddr" "nohup iperf3 -s -p 5101 > /dev/null 2>&1 &"
# ssh root@"$server_ipaddr" "nohup iperf3 -s -p 5102 > /dev/null 2>&1 &"
# ssh root@"$server_ipaddr" "nohup iperf3 -s -p 5101 > iperf3_server_${tcp1}_${testname}.json 2>&1 &"
ssh root@"$server_ipaddr" "nohup iperf3 -s -p 5102 -J > iperf3_server_${tcp2}_${testname}.json 2>&1 &"
ssh root@"$server_ipaddr" "stdbuf -oL ./udp_prague/udp_prague_receiver -p 5106 > udp_prague_receiver_${testname}.json" &


echo "Start tcpdump on the server to capture traffic"
ssh root@"$server_ipaddr" "sudo nohup tcpdump -i ens37 -w pcap_server_${testname}.pcap > /dev/null 2>&1 &"



# Wait for servers to start
sleep 2
echo "Start iperf3 Test"

# Run apply_tc_rules.sh in the background
# ./apply_tc_rules.sh &

nohup ./apply_tc_rules.sh > output.txt 2>&1 < /dev/null &

tc_pid=$!
echo "apply_tc_rules.sh is running in the background with PID $tc_pid"
sleep 20

# ssh root@"$client1_ipaddr" "iperf3 -c 192.168.2.2 -t $duration -p 5101 -J > iperf3_client_${tcp1}_${testname}.json" &
ssh root@"$client2_ipaddr" "iperf3 -c 192.168.2.2 -t $duration -p 5102 -J > iperf3_client_${tcp2}_${testname}.json" &
ssh root@"$client1_ipaddr" "stdbuf -oL ./udp_prague/udp_prague_sender -a 192.168.2.2 -p 5106 -c > udp_prague_sender_${testname}.txt" &
# ssh root@"$client1_ipaddr" "stdbuf -oL ./udp_prague/udp_prague_sender -a 192.168.2.2 -p 5106 -c -b 20480 > udp_prague_sender_${testname}.txt" &


echo "sending completed"

sleep $duration
ssh root@"$router_ipaddr" "sudo killall iperf3;sudo killall tcpdump;" 
ssh root@"$client1_ipaddr" "sudo killall iperf3;sudo killall tcpdump;sudo killall udp_prague_sender;"
ssh root@"$client2_ipaddr" "sudo killall iperf3;sudo killall tcpdump;sudo killall udp_prague_sender;"
ssh root@"$server_ipaddr" "sudo killall iperf3;sudo killall tcpdump;sudo killall udp_prague_receiver;"

# SCP the generated files (JSON and PCAP) to the newly created folder on WSL

echo "Copying files to windows WSL folder..."

echo "Starting downloading data"

# Generate timestamp
timestamp=$(date +"%Y-%m-%d-%H-%M-%S")

# Create main directory with timestamp
base_dir="./data/udp_net_${timestamp}"
mkdir -p "$base_dir"
ssh root@"$router_ipaddr" "dmesg > "dmesg_${testname}_${timestamp}.txt"" 


# Copy server-side JSON and PCAP files to the directory in WSL
scp root@"$server_ipaddr":*.json "$base_dir"/
scp root@"$server_ipaddr":*.pcap "$base_dir"/
scp root@"$server_ipaddr":*.txt "$base_dir"/

# Copy client-side JSON files to the directory in WSL
scp root@"$client1_ipaddr":*.json "$base_dir"/
scp root@"$client2_ipaddr":*.json "$base_dir"/
scp root@"$client1_ipaddr":*.txt "$base_dir"/
scp root@"$client2_ipaddr":*.txt "$base_dir"/
scp root@"$router_ipaddr":*dmesg*.txt "$base_dir"/

echo "File transfer complete."


# Define cleanup function
cleanup() {
    echo "Killing apply_tc_rules.sh with PID $tc_pid"
    kill "$tc_pid" 2>/dev/null
}

# Register the cleanup function to run on script exit
trap cleanup EXIT

# Main script logic goes here
# (e.g. sleep, or whatever task needs to be done)
# Example:
sleep 10

echo "Main script work done."

# When script exits (normally or via Ctrl+C), cleanup will be triggered

# If successful
echo "Test complete"
exit 0
