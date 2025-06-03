#!/bin/bash

# Set basic configuration values
set -x

# Source the settings file
if [ ! -f ./utils/settings.sh ]; then
    echo "Error: settings.sh file not found"
    exit 1
fi
source ./utils/settings.sh
set -euo pipefail

CSV_FILE="Best_Satellite_Australia_Simulation_Log_cleaned_starlink_downlink.csv"
INTERFACE="ens37"
REMOTE_ROUTER="root@$router_ipaddr"

# Ensure settings.sh is sourced
if [ ! -f ./utils/settings.sh ]; then
    echo "Error: settings.sh file not found"
    exit 1
fi
source ./utils/settings.sh

# Clean up any previous configuration
ssh "$REMOTE_ROUTER" "sudo tc qdisc del dev $INTERFACE root || true"

# Skip header
tail -n +2 "$CSV_FILE" | while IFS=',' read -r \
    time s_id snr rssi thrpt ber_mqam ber_qpsk latency \
    mel_id mel_snr mel_rssi mel_thrpt mel_ber_mqam mel_ber_qpsk mel_latency; do

    # Extract and sanitize values
    RATE=$(printf "%.0f" "$thrpt")mbit
    DELAY=$(printf "%.0f" "$latency")ms
    LOSS=$(awk "BEGIN { print $ber_qpsk * 100 }")%

    echo "Applying: Rate=$RATE, Delay=$DELAY, Loss=$LOSS"

    ssh "$REMOTE_ROUTER" bash -c "'
        sudo tc qdisc del dev $INTERFACE root || true
        sudo tc qdisc add dev $INTERFACE root handle 1: netem delay $DELAY loss $LOSS
        sudo tc qdisc add dev $INTERFACE parent 1: handle 2: tbf rate $RATE burst 32kbit latency $DELAY
        sudo tc qdisc add dev $INTERFACE parent 2:1 handle 3: dualpi2
    '"

    sleep 30
done
