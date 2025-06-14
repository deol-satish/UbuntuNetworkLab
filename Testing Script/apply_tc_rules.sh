#!/bin/bash
set -x

# Load environment settings
if [ ! -f ../utils/settings.sh ]; then
    echo "Error: settings.sh not found"
    exit 1
fi
source ../utils/settings.sh

# --- Datapoint 1 ---
echo "Applying 184 Mbps, 6 ms, Loss: 12.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 6ms loss 12%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 184mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"
sleep 20
echo "Completed setup for datapoint 1"
sleep 30

# --- Datapoint 2 ---
echo "Applying 239 Mbps, 6 ms, Loss: 8.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 6ms loss 8%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 239mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 2"
sleep 30

# --- Datapoint 3 ---
echo "Applying 189 Mbps, 6 ms, Loss: 11.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 6ms loss 11%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 189mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 3"
sleep 30

# --- Datapoint 4 ---
echo "Applying 430 Mbps, 6 ms, Loss: 1.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 6ms loss 1%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 430mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 4"
sleep 30

# --- Datapoint 5 ---
echo "Applying 336 Mbps, 6 ms, Loss: 3.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 6ms loss 3%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 336mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 5"
sleep 30

# --- Datapoint 6 ---
echo "Applying 206 Mbps, 6 ms, Loss: 10.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 6ms loss 10%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 206mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 6"
sleep 30

# --- Datapoint 7 ---
echo "Applying 154 Mbps, 7 ms, Loss: 14.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 7ms loss 14%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 154mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 7"
sleep 30

# --- Datapoint 8 ---
echo "Applying 188 Mbps, 7 ms, Loss: 11.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 7ms loss 11%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 188mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 8"
sleep 30

# --- Datapoint 9 ---
echo "Applying 183 Mbps, 7 ms, Loss: 12.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 7ms loss 12%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 183mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 9"
sleep 30

# --- Datapoint 10 ---
echo "Applying 146 Mbps, 7 ms, Loss: 15.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 7ms loss 15%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 146mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 10"
sleep 30

# --- Datapoint 11 ---
echo "Applying 239 Mbps, 7 ms, Loss: 8.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 7ms loss 8%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 239mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 11"
sleep 30

# --- Datapoint 12 ---
echo "Applying 173 Mbps, 7 ms, Loss: 13.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 7ms loss 13%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 173mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 12"
sleep 30

# --- Datapoint 13 ---
echo "Applying 155 Mbps, 6 ms, Loss: 14.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 6ms loss 14%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 155mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 13"
sleep 30

# --- Datapoint 14 ---
echo "Applying 404 Mbps, 6 ms, Loss: 2.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 6ms loss 2%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 404mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 14"
sleep 30

# --- Datapoint 15 ---
echo "Applying 253 Mbps, 6 ms, Loss: 7.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 6ms loss 7%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 253mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 15"
sleep 30

# --- Datapoint 16 ---
echo "Applying 271 Mbps, 6 ms, Loss: 6.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 6ms loss 6%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 271mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 16"
sleep 30

# --- Datapoint 17 ---
echo "Applying 259 Mbps, 6 ms, Loss: 7.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 6ms loss 7%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 259mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 17"
sleep 30

# --- Datapoint 18 ---
echo "Applying 405 Mbps, 6 ms, Loss: 2.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 6ms loss 2%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 405mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 18"
sleep 30

# --- Datapoint 19 ---
echo "Applying 372 Mbps, 6 ms, Loss: 2.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 6ms loss 2%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 372mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 19"
sleep 30

# --- Datapoint 20 ---
echo "Applying 360 Mbps, 6 ms, Loss: 3.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 6ms loss 3%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 360mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 20"
sleep 30

# --- Datapoint 21 ---
echo "Applying 360 Mbps, 7 ms, Loss: 3.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 7ms loss 3%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 360mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 21"
sleep 30

# --- Datapoint 22 ---
echo "Applying 358 Mbps, 6 ms, Loss: 3.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 6ms loss 3%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 358mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 22"
sleep 30

# --- Datapoint 23 ---
echo "Applying 247 Mbps, 6 ms, Loss: 7.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 6ms loss 7%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 247mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 23"
sleep 30

# --- Datapoint 24 ---
echo "Applying 188 Mbps, 7 ms, Loss: 11.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 7ms loss 11%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 188mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 24"
sleep 30

# --- Datapoint 25 ---
echo "Applying 151 Mbps, 7 ms, Loss: 15.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 7ms loss 15%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 151mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 25"
sleep 30

# --- Datapoint 26 ---
echo "Applying 131 Mbps, 8 ms, Loss: 17.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 8ms loss 17%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 131mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 26"
sleep 30

# --- Datapoint 27 ---
echo "Applying 207 Mbps, 7 ms, Loss: 10.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 7ms loss 10%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 207mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 27"
sleep 30

# --- Datapoint 28 ---
echo "Applying 177 Mbps, 7 ms, Loss: 12.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 7ms loss 12%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 177mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 28"
sleep 30

# --- Datapoint 29 ---
echo "Applying 335 Mbps, 6 ms, Loss: 3.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 6ms loss 3%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 335mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 29"
sleep 30

# --- Datapoint 30 ---
echo "Applying 184 Mbps, 6 ms, Loss: 12.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 6ms loss 12%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 184mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 30"
sleep 30

# --- Datapoint 31 ---
echo "Applying 584 Mbps, 5 ms, Loss: 0.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 5ms loss 0%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 584mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 31"
sleep 30

# --- Datapoint 32 ---
echo "Applying 305 Mbps, 5 ms, Loss: 5.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 5ms loss 5%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 305mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 32"
sleep 30

# --- Datapoint 33 ---
echo "Applying 331 Mbps, 5 ms, Loss: 4.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 5ms loss 4%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 331mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 33"
sleep 30

# --- Datapoint 34 ---
echo "Applying 328 Mbps, 5 ms, Loss: 4.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 5ms loss 4%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 328mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 34"
sleep 30

# --- Datapoint 35 ---
echo "Applying 374 Mbps, 5 ms, Loss: 2.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 5ms loss 2%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 374mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 35"
sleep 30

# --- Datapoint 36 ---
echo "Applying 487 Mbps, 5 ms, Loss: 1.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 5ms loss 1%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 487mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 36"
sleep 30

# --- Datapoint 37 ---
echo "Applying 369 Mbps, 6 ms, Loss: 2.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 6ms loss 2%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 369mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 37"
sleep 30

# --- Datapoint 38 ---
echo "Applying 287 Mbps, 6 ms, Loss: 5.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 6ms loss 5%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 287mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 38"
sleep 30

# --- Datapoint 39 ---
echo "Applying 297 Mbps, 6 ms, Loss: 5.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 6ms loss 5%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 297mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 39"
sleep 30

# --- Datapoint 40 ---
echo "Applying 143 Mbps, 6 ms, Loss: 16.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 6ms loss 16%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 143mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 40"
sleep 30

# --- Datapoint 41 ---
echo "Applying 118 Mbps, 7 ms, Loss: 18.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 7ms loss 18%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 118mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 41"
sleep 30

# --- Datapoint 42 ---
echo "Applying 173 Mbps, 8 ms, Loss: 13.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 8ms loss 13%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 173mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 42"
sleep 30

# --- Datapoint 43 ---
echo "Applying 130 Mbps, 8 ms, Loss: 17.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 8ms loss 17%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 130mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 43"
sleep 30

# --- Datapoint 44 ---
echo "Applying 259 Mbps, 6 ms, Loss: 7.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 6ms loss 7%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 259mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 44"
sleep 30

# --- Datapoint 45 ---
echo "Applying 152 Mbps, 7 ms, Loss: 15.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 7ms loss 15%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 152mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 45"
sleep 30

# --- Datapoint 46 ---
echo "Applying 285 Mbps, 6 ms, Loss: 5.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 6ms loss 5%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 285mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 46"
sleep 30

# --- Datapoint 47 ---
echo "Applying 419 Mbps, 5 ms, Loss: 1.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 5ms loss 1%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 419mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 47"
sleep 30

# --- Datapoint 48 ---
echo "Applying 417 Mbps, 5 ms, Loss: 1.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 5ms loss 1%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 417mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 48"
sleep 30

# --- Datapoint 49 ---
echo "Applying 199 Mbps, 5 ms, Loss: 11.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 5ms loss 11%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 199mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 49"
sleep 30

# --- Datapoint 50 ---
echo "Applying 245 Mbps, 5 ms, Loss: 7.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 5ms loss 7%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 245mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 50"
sleep 30

# --- Datapoint 51 ---
echo "Applying 420 Mbps, 5 ms, Loss: 1.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 5ms loss 1%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 420mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 51"
sleep 30

# --- Datapoint 52 ---
echo "Applying 782 Mbps, 5 ms, Loss: 0.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 5ms loss 0%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 782mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 52"
sleep 30

# --- Datapoint 53 ---
echo "Applying 459 Mbps, 5 ms, Loss: 1.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 5ms loss 1%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 459mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 53"
sleep 30

# --- Datapoint 54 ---
echo "Applying 300 Mbps, 6 ms, Loss: 5.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 6ms loss 5%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 300mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 54"
sleep 30

# --- Datapoint 55 ---
echo "Applying 265 Mbps, 6 ms, Loss: 6.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 6ms loss 6%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 265mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 55"
sleep 30

# --- Datapoint 56 ---
echo "Applying 294 Mbps, 6 ms, Loss: 5.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 6ms loss 5%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 294mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 56"
sleep 30

# --- Datapoint 57 ---
echo "Applying 139 Mbps, 8 ms, Loss: 16.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 8ms loss 16%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 139mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 57"
sleep 30

# --- Datapoint 58 ---
echo "Applying 149 Mbps, 7 ms, Loss: 15.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 7ms loss 15%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 149mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 58"
sleep 30

# --- Datapoint 59 ---
echo "Applying 222 Mbps, 8 ms, Loss: 9.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 8ms loss 9%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 222mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 59"
sleep 30

# --- Datapoint 60 ---
echo "Applying 232 Mbps, 7 ms, Loss: 8.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 7ms loss 8%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 232mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 60"
sleep 30

# --- Datapoint 61 ---
echo "Applying 267 Mbps, 6 ms, Loss: 6.0000%"

# Configure ens37 (delay + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 root handle 1: netem delay 6ms loss 6%"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens37 parent 1:1 handle 2: dualpi2"

# Configure ens38 (rate + dualpi2)
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 root handle 1: tbf rate 267mbit burst 32kbit latency 100ms"
ssh root@"$router_ipaddr" "sudo tc qdisc add dev ens38 parent 1:1 handle 2: dualpi2"

echo "Completed setup for datapoint 61"
sleep 30

# Cleanup
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens37 root 2>/dev/null || true"
ssh root@"$router_ipaddr" "sudo tc qdisc del dev ens38 root 2>/dev/null || true"
echo "All datapoints processed."
exit 0