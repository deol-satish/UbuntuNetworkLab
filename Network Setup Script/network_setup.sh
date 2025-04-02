#!/bin/bash

# Set basic configuration values
set -x

# Source the settings file
if [ ! -f ../utils/settings.sh ]; then
    echo "Error: settings.sh file not found"
    exit 1
fi

source ../utils/settings.sh

# Check if variables are set
if [[ -z "$routerport" || -z "$sshkeypath" || -z "$vmhostaddr" ]]; then
    echo "Error: One or more required variables are not set."
    exit 1
fi

echo "Commands to enable IP forwarding, configure interfaces, and set up NAT"

# Maybe do not use ip link set down

router_setup_commands="
sudo ip link set ens37 down;
sudo ip link set ens38 down;
sudo ip link set ens39 down;
echo 'net.ipv4.ip_forward=1' | sudo tee -a /etc/sysctl.conf;
sudo sysctl -p;
sudo ip addr add 192.168.1.1/24 dev ens37;
sudo ip addr add 192.168.2.1/24 dev ens38;
sudo ip addr add 192.168.3.1/24 dev ens39;
sudo ip link set ens37 up;
sudo ip link set ens38 up;
sudo ip link set ens39 up;
"

client1_setup_commands="
sudo ip link set ens37 down;
sudo ip addr add 192.168.1.2/24 dev ens37;
sudo ip route add default via 192.168.1.1;
sudo ip link set ens37 up;
"

client2_setup_commands="
sudo ip link set ens37 down;
sudo ip addr add 192.168.2.2/24 dev ens37;
sudo ip route add default via 192.168.2.1;
sudo ip link set ens37 up;
"


server_setup_commands="
sudo ip link set ens37 down;
sudo ip addr add 192.168.3.2/24 dev ens37;
sudo ip route add 192.168.1.0/24 via 192.168.3.1;
sudo ip route add 192.168.2.0/24 via 192.168.3.1;
sudo ip link set ens37 up;
"


# Execute the commands remotely via SSH

ssh root@"$router_ipaddr" "$router_setup_commands"
ssh root@"$client1_ipaddr" "$client1_setup_commands"
ssh root@"$client2_ipaddr" "$client2_setup_commands"
ssh root@"$server_ipaddr" "$server_setup_commands"

# ssh root@"$router_ipaddr" "$router_setup_commands" &
# ssh root@"$client1_ipaddr" "$client1_setup_commands" &
# ssh root@"$client2_ipaddr" "$client2_setup_commands" &
# ssh root@"$server_ipaddr" "$server_setup_commands" &


## For VirtualBox
# ssh -p "$routerport" root@"$vmhostaddr" "$router_setup_commands"
# ssh -p "$client1port" root@"$vmhostaddr" "$client1_setup_commands"
# ssh -p "$client2port" root@"$vmhostaddr" "$client2_setup_commands"
# ssh -p "$serverport" root@"$vmhostaddr" "$server_setup_commands"
# wait


# If successful
echo "Test complete"
exit 0

# Error handler
out() {
    echo "Abort test"
    exit 1
}
